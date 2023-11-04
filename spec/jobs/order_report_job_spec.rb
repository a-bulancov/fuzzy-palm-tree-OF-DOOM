require 'rails_helper'

RSpec.describe OrderReportJob, type: :job do
  let(:user) { create(:user) }
  let(:order) { create(:order) }
  let(:args) { { username: user.username }.to_json }

  it 'enqueues a job and sends a CSV report' do
    expect(SendCsvMailer).to receive_message_chain(:send_report, :deliver_now)

    OrderReportJob.new.perform(user.id, args)
    OrderReportJob.drain
  end
end
