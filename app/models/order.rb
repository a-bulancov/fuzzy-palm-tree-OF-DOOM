require 'csv'

class Order < ApplicationRecord
  belongs_to :user

  def self.to_csv
    attributes = %w[id order_date price user_id]

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.find_each(batch_size: 1_000) do |user|
        csv << attributes.map { |attr| user.send(attr) }
      end
    end
  end
end
