class ConnectionLog < ActiveRecord::Base
  belongs_to :spe

  def self.log_connection(spe)
    c = spe.connection_log.order(:updated_at).last
    if c.nil? || (Time.now - c.updated_at > 900)
      c = ConnectionLog.new(spe_id: spe.id)
    else
      c.touch
    end
    c.save
  end
end
