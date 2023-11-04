require 'rails_helper'

RSpec.describe SendCsvMailer, type: :mailer do
  include EmailSpec::Helpers
  include EmailSpec::Matchers

  let(:user) { create(:user, email: 'user@example.com', username: 'example_user') }
  let(:file_content) { Tempfile.new('orders_report.csv') }

  after do
    file_content.close
    file_content.unlink
  end

  describe 'send_report' do
    let(:mail) { SendCsvMailer.send_report(user.id, file_content) }

    it 'sends the CSV report to the user' do
      expect(mail).to deliver_to(user.email)
      expect(mail).to have_subject("CSV orders report for #{user.username}")
      expect(mail).to have_body_text('Your requested file in attachments.')

      attachment = mail.attachments[0]

      expect(attachment).to be_a(Mail::Part)
      expect(attachment.content_type).to start_with('text/csv')
      expect(attachment.filename).to eq('orders_report.csv')
    end
  end
end
