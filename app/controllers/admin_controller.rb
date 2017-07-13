require 'base64'
require 'digest/sha1'

class AdminController < ApplicationController
  def login
    if request.post?
      if check_authenticity(params[:key])
        set_admin_cookie(params[:key])
        redirect_to_page
      elsif at = AccessToken.find_by(voucher: params[:key])
        at.voucher = nil
        at.save
        @error = <<-MSG
          Voucher valid. Your token is "#{at.token}".
          <br/>Please write it down, as you won't have any
          other way to retrieve it the future
        MSG
      else
        @error = "Clé invalide"
      end
    end

    if access_level > 0
      @error += "<br/>" unless @error.nil?
      @error ||= ""
      @error += "ACCESS DENIED : acess level too low"
    end
  end

  def index
    grant_access(:general)
  end

  def freeze
    grant_access(:general)
    redirect_to "/admin" and return unless request.post?
    category = params[:category].to_sym
    if Config::frozen? category
      Config.unfreeze category
    else
      Config::freeze category
      (User.destroy_all; UsersAnswer.destroy_all) if category == :answer_points
    end
    redirect_to "/admin"
  end

  def balance
    grant_access(:general)
    redirect_to "/admin" and return unless request.post?
    balance_points
    redirect_to "/admin"
  end

  def toggle_multiple_flag
    grant_access(:general)
    render nothing: true, status: 400 and return unless params.has_key?(:question_id)
    q = Question.find params[:question_id]
    unless q.nil?
      q.multiple = !q.multiple
      q.save
    end
    render nothing: true, status: 200
  end

  def remove_questions
    grant_access(:general)
    render nothing: true, status: 400 and return unless params.has_key?(:threshold) && params[:threshold].match(/^\d+$/)
    Question.where("vote_count <= #{params[:threshold]}").map(&:shred)
    redirect_to "/admin"
  end

  def self.levels
    @@levels
  end

  def create_token
    grant_access(:general)
    l = params.has_key?(:level) ? params[:level].to_i : nil
    level_valid = !l.nil? && l <= @access_level
    render nothing: true, status: 400 and return unless level_valid
    a = AccessToken::generate(l)
    @voucher = a.voucher
  end

  def seed_index
    grant_access(:general)
  end

  def seed_spes
    grant_access(:general)
    salt = Rails.application.secrets.key_salt
    file = params[:seed]
    file.read.each_line do |line|
      line = line.split(':')
      username, full_name, email = line[0],line[1],line[2..-1].join(':')
      Spe.new(username: username, full_name: full_name, email: email,
              key: generate_key(full_name, email, salt)).save
    end
  end

  def send_welcome_email
    grant_access(:general)
    Spe.find_each do |spe|
      UserMailer.welcome(spe).deliver
    end
  end

  def reset_spe_database
    grant_access(:general)
    Question.find_each { |q| q.shred }
    Spe.destroy_all
  end

  def post_announcement
    Announcement.new(content: params[:announcement]).save
    redirect_to "/message_board"
  end

  private
  def generate_key(full_name, email, salt)
    Digest::SHA1.hexdigest(Base64::encode64(full_name)+salt.to_s+email)[0...8]
  end

  def balance_points
    total = Rails.configuration.x.total_points_per_question

    s = Hash.new { |h,q_id| h[q_id] = Hash.new { |k, spe_id| h[spe_id] = 0 } }
    ActiveRecord::Base.connection.execute(points_query).each do |res|
      s[res["question_id"].to_i][res["spe_id"].to_i] = res["score"].to_i
    end

    Question.all.order(:id).each do |q|
      answers = q.answer
      answers.each do |a|
        ap_present = Hash.new { |h,k| h[k] = false }
        # Balance points when already present
        a.answer_points.each do |ap|
          ap_present[ap.spe_id] = true
          if s[q.id][ap.spe_id] == total
            # everythink ok
          elsif s[q.id][ap.spe_id] == 0
            ap.score = total / answers.size
          else
            ap.score = (total * ap.score / s[q.id][ap.spe_id].to_f).to_i
          end
          ap.save
        end
        # Create when not present
        Spe.all.map(&:id).each do |id|
          next if ap_present[id]
          ap = AnswerPoint.new(answer_id: a.id, spe_id: id)
          ap.score = (s[q.id][id] == 0) ? (total / answers.size) : 0
          ap.save
        end
      end
    end
  end

  def points_query
    <<-SQL
      SELECT question_id, spe_id, SUM(score)
       FROM answer_points ap
       JOIN answers a ON a.id = ap.answer_id
      GROUP BY question_id, spe_id
      ORDER BY question_id, spe_id
    SQL
  end


  @@levels = [ :regular, :lieutenant, :general, :dictator ]
  def grant_access(level)
    level = @@levels.index(level) if level.is_a?(Symbol)
    access_level >= level or redirect_to "/admin/login"
  end

  def access_level
    at = AccessToken.find_by(token: get_admin_cookie)
    @access_level = at.nil? ? 0 : at.level
  end

  def check_authenticity(token)
    !AccessToken.find_by(token: token).nil?
  end

  def get_admin_cookie
    cookies.permanent[:AdopteUnSpe_key]
  end

  def set_admin_cookie(key)
    cookies.permanent[:AdopteUnSpe_key] = key
  end

  def redirect_to_page
    params[:page] ||= "/admin"
    redirect_to params[:page]
  end
end
