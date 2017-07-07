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
    a = vote.find_by(spe_id: spe.id)
    a.nil? ? 0 : a.vote
  end

  def chosen_vote_class(spe)
    ["", "upvoted", "downvoted"][chosen_vote(spe)]
  end

  def chosen_coeff(spe)
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

  def balance_points(spe)
    if spe.is_a? Spe
      spe = spe.username.to_sym
    end
    sum = self.answer.map {|a| a[spe] }.sum.to_f

    if sum == 10
      # everything ok
    elsif sum == 0
      c = self.answer.size
      self.answer.each do |a|
        a[spe] = (10.0 / c).to_i
        a.save
      end
    else
      self.answer.each do |a|
        a[spe] = (10.0 * (a[spe] / sum)).to_i
        a.save
      end
    end
  end

  def shred
    Answer.where(question_id: id).destroy_all
    Vote.where(question_id: id).destroy_all
    SuggestedCoeff.where(question_id: id).destroy_all
    Comment.where(question_id: id).destroy_all
    destroy
  end
end
