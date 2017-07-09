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
end
