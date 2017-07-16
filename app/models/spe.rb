class Spe < ActiveRecord::Base
  has_many :connection_log
  has_many :vote
  has_many :suggested_coeff
  has_many :answer_point

  def last_connection
    c = connection_log.order(:updated_at).last
    c.nil? ? "Never" : c.updated_at.strftime("%Y-%m-%d %H:%M:%S")
  end

  def time_spent_on_site
    s = seconds_spent_on_site
    "#{(s / 3600).to_s.rjust(2, '0')}:" +
      "#{(s / 60 % 60).to_s.rjust(2, '0')}:" +
      "#{(s % 60).to_s.rjust(2, '0')}"
  end

  def seconds_spent_on_site
    s = 0
    connection_log.each { |c| s += c.updated_at - c.created_at }
    s.to_i
  end

  def build_all_caches
    points_cache; vote_cache; coeff_cache; true
  end

  def points_cache_built? ; !@points_cache.nil? ; end
  def vote_cache_built?   ; !@vote_cache.nil?   ; end
  def coeff_cache_built?  ; !@coeff_cache.nil?  ; end

  def points_cache
    return @points_cache unless @points_cache.nil?
    @points_cache = Hash.new { 0 }
    answer_point.each do |ap|
      @points_cache[ap.answer_id] = ap.score
    end
    @points_cache
  end

  def vote_cache
    return @vote_cache unless @vote_cache.nil?
    @vote_cache = Hash.new { 0 }
    vote.each do |v|
      @vote_cache[v.question_id] = v.vote
    end
    @vote_cache
  end

  def coeff_cache
    return @coeff_cache unless @coeff_cache.nil?
    @coeff_cache = Hash.new { 0 }
    suggested_coeff.each do |s|
      @coeff_cache[s.question_id] = s.coeff
    end
    @coeff_cache
  end

  def self.build_username_cache
    cache = {}
    Spe.find_each { |s| cache[s.id] = s.username }
    $username_cache = cache
  end

  # Retrieve list of filtered questions
  def unanswered_questions; questions_not_matching_query(answered_questions_query); end
  def unvoted_questions; questions_not_matching_query(voted_questions_query); end
  def unrated_questions; questions_not_matching_query(rated_questions_query); end

  # Count filtered questions
  def unanswered_questions_count; count_not_matching_query(answered_questions_query); end
  def unvoted_questions_count; count_not_matching_query(voted_questions_query); end
  def unrated_questions_count; count_not_matching_query(rated_questions_query); end

  private
  def questions_not_matching_query(query)
    all = Question.all.order(:id).select(:id).map { |i| i[:id] }
    matching = ActiveRecord::Base.connection.execute(query).map {|r| r["id"].to_i }
    (all - matching).map { |i| Question.find i }
  end

  def count_not_matching_query(query)
    query = "SELECT COUNT(*) FROM (#{query.chomp}) t"
    Question.count - ActiveRecord::Base.connection.execute(query).first["count"].to_i
  end

  def answered_questions_query
    <<-SQL
      SELECT q.id FROM questions q
        JOIN answers a ON a.question_id = q.id
        JOIN answer_points ap ON ap.answer_id = a.id
      WHERE ap.spe_id = #{id}
      GROUP BY q.id
      HAVING SUM(score) = #{Rails.configuration.x.total_points_per_question}
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
