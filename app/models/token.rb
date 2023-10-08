class Token < ApplicationRecord
  def expired?
    Time.now > expires
  end
end
