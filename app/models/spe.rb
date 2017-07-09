class Spe < ActiveRecord::Base
  has_many :connection_log
  has_many :vote
  has_many :suggested_coeff

  def last_connection
    c = connection_log.order(:updated_at).last
    c.nil? ? "Never" : c.updated_at
  end

  def time_spent_on_site
    s = 0
    connection_log.each { |c| s += c.updated_at - c.created_at }
    s
  end

  def unanswered_questions
    questions_not_matching_query(answered_questions_query)
  end

  def unvoted_questions
    questions_not_matching_query(voted_questions_query)
  end

  def unrated_questions
    questions_not_matching_query(rated_questions_query)
  end

  private
  def questions_not_matching_query(query)
    all = Question.all.select(:id).map { |i| i[:id] }
    matching = ActiveRecord::Base.connection.execute(query).map {|r| r["id"].to_i }
    (all - matching).map { |i| Question.find i }
  end

  def answered_questions_query
    <<-SQL
      SELECT q.id FROM questions q
        JOIN answers a ON a.question_id = q.id
        JOIN answer_points ap ON ap.answer_id = a.id
      WHERE ap.spe_id = #{id}
      GROUP BY q.id
      HAVING SUM(score) = 10
    SQL
  end

  def voted_questions_query
    <<-SQL
      SELECT q.id FROM questions q
        JOIN votes v ON v.question_id = q.id
      WHERE v.spe_id = #{id} AND v.vote <> 0
    SQL
  end

  def rated_questions_query
    <<-SQL
      SELECT q.id FROM questions q
        JOIN suggested_coeffs c ON c.question_id = q.id
      WHERE c.spe_id = #{id} AND c.coeff <> 0
    SQL
  end
end
