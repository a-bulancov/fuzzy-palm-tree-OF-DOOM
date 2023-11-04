require 'rails_helper'

Sidekiq::Testing.fake!

RSpec.describe OrderReportJob, type: :job do
  let(:user) { create(:user, username: 'example_user') }
  let(:args) { { username: user.username }.to_json }
  let(:order) { create(:order, user_id: user.id) }

  it 'sends a CSV report to the user' do
    expect(User).to receive(:find_by).with(username: user.username).and_return(user)
    expect(FindOrders).to receive(:new).with(Order.all).and_return(find_orders_double = double)
    expect(find_orders_double).to receive(:call).with(hash_including(user_id: user.id)).and_return([order])
    expect(SendCsvMailer).to receive_message_chain(:send_report, :deliver_now)

    OrderReportJob.perform_async(args)
    OrderReportJob.drain
  end
end
