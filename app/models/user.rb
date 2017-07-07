require 'digest/sha1'

class User < ActiveRecord::Base
  has_many :users_answer

  def calculate_token
    token = Digest::SHA1.hexdigest "#{first_name}_#{last_name}<#{email}>[#{phonenumber}]"
    self.token = token
    self.save
    token
  end
end
