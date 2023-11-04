require 'rails_helper'

RSpec.describe Order, type: :model do
  describe '.to_csv' do
    let!(:user) { create(:user) }
    let!(:order) { create(:order, user: user) }
    let(:csv) { Order.to_csv }

    it 'returns CSV content with headers' do
      expected_headers = 'id,order_date,price,user_id'
      expect(csv).to include(expected_headers)
    end

    it 'includes order data in the CSV' do
      expected_row = "#{order.id},#{order.order_date},#{order.price},#{order.user_id}"
      expect(csv).to include(expected_row)
    end
  end
end
