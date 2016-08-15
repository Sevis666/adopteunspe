class Question < ActiveRecord::Base
  has_many :answer
  has_many :comment
  has_one :vote
  has_one :suggested_coeff

  @@students = %i(abecassis athor azizian beaulieu boutin bruneaux brunod
bustillo careil chardon cortes diridollou dumond fievet flechelles
gaborit georges godefroy haas khalfallah lanfranchi lecat ledaguenel laigret
lengele lequen lerbet lezanne lozach medmoun nguyen preumont qrichi rabineau ravetta rael
ren robina robind sahli scotti sourice steiner thomas vanel vital zhou)

  def answers
    ans = []
    answer.each do |a|
      ans << a.answer
    end
    ans
  end

  def comments
    com = []
    comment.order(Comment.arel_table['created_at'].asc).each do |c|
      com << {user: c.username, comment: c.comment}
    end
    com
  end

  def chosen_vote(spe)
    s = spe.username.to_sym
    a = Vote.where(question_id: id).select(:id, s).first
    unless a.is_a? Vote
      a = Vote.new
      self.vote = a
    end
    a[s]
  end

  def chosen_vote_class(spe)
    a = ["", "upvoted", "downvoted"]
    a[chosen_vote(spe)]
  end

  def chosen_coeff(spe)
    s = spe.username.to_sym
    a = SuggestedCoeff.where(question_id: id).select(:id, s).first
    unless a.is_a? SuggestedCoeff
      a = SuggestedCoeff.new
      self.suggested_coeff = a
    end
    a[s]
  end

  def upvote(spe)
    set_vote(1, spe)
  end

  def downvote(spe)
    set_vote(-1, spe)
  end

  def set_vote(n, spe)
    d = n - vote[spe.username.to_sym]
    if d != 0
      self.vote_count = vote_count + d
      self.save
      vote[spe.username.to_sym] = n
      vote.save
    end
    update_vote_count
  end

  def update_vote_count
    s = 0
    v = vote
    @@students.each do |sym|
      s += v[sym]
    end
    if s != vote_count
      self.vote_count = s
      self.save
    end
    s
  end

  def set_coeff(spe, new_coeff)
    suggested_coeff[spe.username.to_sym] = new_coeff
    suggested_coeff.save
    update_coeff
  end

  def update_coeff
    s = {}
    @@students.each do |sym|
      s[sym] = suggested_coeff[sym]
    end
    s = s.values.select {|i| i > 0}
    c = s.sum.to_f / s.size
    if c != coeff
      self.coeff = c
      self.save
    end
  end
end
