# frozen_string_literal: true

class Token < ApplicationRecord
  def expired?
    Time.current > expires
  end
end
