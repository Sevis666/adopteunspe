class AdminController < ApplicationController
  def index
  end

  def freeze
    redirect_to "/admin" and return unless request.post?
    category = params[:category].to_sym
    if Config::frozen? category
      Config.unfreeze category
    else
      Config::freeze category
    end
    redirect_to "/admin"
  end

  def balance
    redirect_to "/admin" and return unless request.post?
    balance_points
    redirect_to "/admin"
  end

  def toggle_multiple_flag
    render nothing: true, status: 400 unless params.has_key?(:question_id)
    q = Question.find params[:question_id]
    unless q.nil?
      q.multiple = !q.multiple
      q.save
    end
    render nothing: true, status: 200
  end

  private
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
end
