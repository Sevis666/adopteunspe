class AccessToken < ActiveRecord::Base
  def self.generate(level)
    a = AccessToken.new(level: level,
                        token: random_string(16),
                        voucher: random_string(6))
    a.save
    a
  end

  private
  def self.random_string(size)
    alph = [('a'..'z'),('A'..'Z'),('0'..'9')].map(&:to_a).flatten
    (0...size).map { alph[rand(alph.size)] }.join
  end
end
