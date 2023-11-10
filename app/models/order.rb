# frozen_string_literal: true

class Order < ApplicationRecord
  def self.ransackable_attributes(auth_object = nil)
    %w[amount date user_id]
  end
end
