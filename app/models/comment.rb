class Comment < ActiveRecord::Base
  def username
    Spe.find(user_id).full_name
  end
end
