class Announcement < ActiveRecord::Base
  def expired?
    (Time.now - updated_at) > 3600 * 24 * 7
  end
end
