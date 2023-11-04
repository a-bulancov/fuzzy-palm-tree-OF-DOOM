require 'csv'

class Order < ApplicationRecord
  belongs_to :user

  def self.to_csv(file_path, batch_size = 1_000)
    attributes = %w[id order_date price user_id]

    CSV.open(file_path, 'w', write_headers: true, headers: true) do |csv|
      csv << attributes

      all.find_each(batch_size: batch_size) do |user|
        csv << attributes.map { |attr| user.send(attr) }
      end
    end
  end
end
