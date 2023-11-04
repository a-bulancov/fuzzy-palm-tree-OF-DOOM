require 'rails_helper'
require 'tempfile'

RSpec.describe Order, type: :model do
  describe '.to_csv' do
    it 'generates a CSV file with headers and data' do
      attributes = %w[id order_date price user_id]
      create_list(:order, 3)

      temp_file = Tempfile.new('orders.csv')
      file_path = temp_file.path

      Order.to_csv(file_path)

      csv_data = CSV.read(file_path, headers: true)
      expect(csv_data.headers).to eq(attributes)

      # Проверяем, что данные в файле совпадают с данными из базы данных
      Order.find_each do |order|
        expect(csv_data.find { |row| row['id'].to_i == order.id }).not_to be_nil
        expect(csv_data.find { |row| row['order_date'] == order.order_date.to_s }).not_to be_nil
        expect(csv_data.find { |row| row['price'].to_f == order.price }).not_to be_nil
        expect(csv_data.find { |row| row['user_id'].to_i == order.user_id }).not_to be_nil
      end

      temp_file.close
      temp_file.unlink
    end
  end
end
