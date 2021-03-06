class ProcessingController < ApplicationController
  protect_from_forgery except: [:reset_users, :reset_godfathers, :match_pairs, :force_match]

  def reset_users
    check_token or return
    User.destroy_all
    UsersAnswer.destroy_all
    render nothing: true, status: 200
  end

  def reset_godfathers
    check_token or return
    stmts = ["UPDATE users SET godfather_id = NULL",
             "UPDATE spes SET elligible = true"]
    stmts.each do |stmt|
      ActiveRecord::Base.connection.execute(stmt)
    end
    render nothing: true, status: 200
  end

  def delete_user
    check_token or return
    User.find(params[:user_id]).delete
    UsersAnswer.where(user_id: params[:user_id]).destroy_all
    render nothing: true, status: 200
  end

  def match_pairs
    check_token or return
    render nothing: true, status: 200
    puts "Starting algorithm"

    build_table

    spes = {}
    Spe.all.order(:id).each do |s|
      spes[s.id] = SpeStudent.new(s.full_name, s.id, s.elligible)
    end
    sups = {}
    User.where("godfather_id IS NULL").order(:id).each do |u|
      sups[u.id] = SupStudent.new(u.first_name + " " + u.last_name, u.id)
    end
    puts "\n\nDone loading"
    while sups.size > spes.select {|id, s| s.elligible }.size
      pre_match(sups, spes)
    end

    while couple = sups.find {|id, sup| sup.single?} do
      id, s = couple
      puts "\nConsidering single sup #{s}"
      s.propose_to spes[s.best_partner]
    end
    puts "\n\nFound matching pairs"

    sups.each do |id, s|
      puts "#{s} <-> #{s.fiance}"
      u = User.find(id)
      u.godfather_id = s.fiance.spe_id
      u.save
    end

    puts "\n\nProcessing ended"
  end

  def force_match
    check_token or return
    s = Spe.find_by(username: params[:spe_username])
    u = User.find(params[:user_id])
    return if s.nil? || u.nil?
    s.elligible = false
    u.godfather_id = s.id
    u.save
    s.save
    render nothing: true, status: 200
  end

  private
  def check_token
    at = AccessToken.find_by(token: params[:token])
    render nothing: true, status: 403 if at.nil? || at.level < 1
    !at.nil? && at.level >= 1
  end

  def scores_query
    <<-SQL
      SELECT ap.spe_id AS spe, SUM(q.coeff * ap.score) AS score
        FROM (SELECT * FROM users_answers WHERE user_id = ?) ua
        INNER JOIN answers a ON a.question_id = ua.question_id
                          AND a.answer_number = ua.answer_number
        JOIN answer_points ap ON ap.answer_id = a.id
        JOIN questions q ON q.id = a.question_id
      GROUP BY ap.spe_id
    SQL
  end

  def retrieve_scores(user)
    scores = Hash.new { 0 }
    ActiveRecord::Base.connection.execute(scores_query.sub("?", user.id.to_s))
      .each { |h| scores[h["spe"].to_i] = h["score"].to_i }
    scores
  end

  def build_table
    Student::affinity_table = {}
    User.where("godfather_id IS NULL").order(:id).each do |u|
      Student::affinity_table[u.id] = retrieve_scores(u)
    end
  end

  def pre_match(sups, spes)
    best_scores = {}
    sups.each {|id, s| best_scores[id] = s.affinity_with(spes[s.best_partner]) }
    s = sups[best_scores.key best_scores.values.max]
    bp = s.best_partner
    puts "sup #{s} has highest affinity with #{spes[bp]}"
    c = User.where("godfather_id = #{bp}").count
    case c
    when 0, 1
      t = Spe.find(bp)
      t.elligible = false
      t.save
      spes[bp].elligible = false
    else
      puts "Already taken. Forget him/her"
      s.forget_best_partner
      return
    end
    u = User.find(s.user_id)
    u.godfather_id = s.best_partner
    u.save
    sups.delete(s.user_id)
  end

  class Student
    class << self
      attr_accessor :affinity_table
    end

    def initialize(name)
      @name = name
      @fiance = nil
    end
    attr_reader :name
    attr_accessor :fiance

    def to_s
      @name
    end

    def free
      @fiance = nil
    end

    def single?
      @fiance.nil?
    end

    def engage(person)
      self.fiance = person
      person.fiance = self
    end
  end

  class SupStudent < Student
    def initialize(name, user_id)
      super(name)
      @proposals = Hash.new { false }
      @user_id = user_id
    end
    attr_reader :user_id

    def best_partner
      best_score = nil
      best_id = nil
      Student::affinity_table[@user_id].each do |id, points|
        unless @proposals[id]
          if best_score.nil? || best_score < points
            best_score = points
            best_id = id
          end
        end
      end
      best_id
    end

    def forget_best_partner
      Student::affinity_table[@user_id][best_partner] = 0
      puts Student::affinity_table.inspect
    end

    def affinity_with(person)
      Student::affinity_table[@user_id][person.spe_id]
    end

    def propose_to(person)
      puts "#{self} proposes to #{person} (score #{affinity_with(person)})"
      @proposals[person.spe_id] = true
      person.respond_to_proposal(self)
    end
  end

  class SpeStudent < Student
    def initialize(name, spe_id, elligible)
      super(name)
      @spe_id = spe_id
      @elligible = elligible
    end
    attr_reader :spe_id
    attr_accessor :elligible

    def affinity_with(person)
      Student::affinity_table[person.user_id][@spe_id]
    end

    def better_choice?(person)
      affinity_with(person) > affinity_with(@fiance)
    end

    def respond_to_proposal(person)
      if @elligible && single?
        puts engagement_message(person)
        engage(person)
      elsif @elligible && better_choice?(person)
        puts dumping_message(person)
        @fiance.free
        engage(person)
      else
        puts refusal_message(person)
      end
    end

    def engagement_message(person)
      "#{self} accepts proposal from #{person}"
    end

    def dumping_message(person)
      "#{self} dumps #{@fiance} for #{person} (previous score #{affinity_with(@fiance)})"
    end

    def refusal_message(person)
      s = "#{self} refuses proposal from #{person} "
      s += "(already taken)" unless @elligible
      s += "(previous score #{affinity_with(@fiance)})" unless @fiance.nil?
      s
    end
  end
end
