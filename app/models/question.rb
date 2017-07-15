class Question < ActiveRecord::Base
  has_many :answer
  has_many :comment
  has_many :vote
  has_many :suggested_coeff

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
    return spe.vote_cache[id] if spe.vote_cache_built?
    a = vote.find_by(spe_id: spe.id)
    a.nil? ? 0 : a.vote
  end

  def chosen_vote_class(spe)
    ["", "upvoted", "downvoted"][chosen_vote(spe)]
  end

  def chosen_coeff(spe)
    return spe.coeff_cache[id] if spe.coeff_cache_built?
    a = suggested_coeff.find_by(spe_id: spe.id)
    a.nil? ? 0 : a.coeff
  end

  def upvote(spe)
    set_vote(spe, 1)
  end

  def downvote(spe)
    set_vote(spe, -1)
  end

  def set_vote(spe, n)
    d = n - chosen_vote(spe)
    if d != 0
      self.vote_count = vote_count + d
      self.save
      v = vote.find_by(spe_id: spe.id) || Vote.new(question_id: id, spe_id: spe.id)
      v.vote = n
      v.save
    end
  end

  def update_vote_count
    s = vote.sum(:vote)
    if s != vote_count
      self.vote_count = s
      self.save
    end
    s
  end

  def set_coeff(spe, new_coeff)
    s = suggested_coeff.find_by(spe_id: spe.id) || SuggestedCoeff.new(question_id: id, spe_id: spe.id)
    s.coeff = new_coeff
    s.save
    update_coeff
  end

  def update_coeff
    return 0 if suggested_coeff.empty?
    c = suggested_coeff.sum(:coeff) / suggested_coeff.count
    if c != coeff
      self.coeff = c
      self.save
    end
    c
  end

  def shred
    Log::log_shred_question(self)
    Answer.where(question_id: id).map(&:shred)
    Vote.where(question_id: id).destroy_all
    SuggestedCoeff.where(question_id: id).destroy_all
    Comment.where(question_id: id).destroy_all
    destroy
  end
end
