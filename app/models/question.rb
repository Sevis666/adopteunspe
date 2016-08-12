class Question < ActiveRecord::Base
  has_many :answer
  has_many :comment

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
end
