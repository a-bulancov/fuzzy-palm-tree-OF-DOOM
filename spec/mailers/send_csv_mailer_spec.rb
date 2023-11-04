require "rails_helper"

RSpec.describe SendCsvMailer, type: :mailer do
  describe 'send_report' do
    let(:user) { create(:user, email: 'user@example.com', username: 'example_user') }
    let(:filename) { 'report_data' }
    let(:mail) { SendCsvMailer.send_report(user.id, filename) }

    it 'renders the headers' do
      expect(mail.subject).to eq("CSV orders report for #{user.username}")
      expect(mail.to).to eq([user.email])
    end

    it 'attaches the CSV file' do
      attachment = mail.attachments['orders_report.csv']
      expect(attachment).to be_present
      expect(attachment.content_type).to eq('text/csv')
      expect(attachment.body.raw_source).to eq(filename)
    end

    it 'includes the user in the mail body' do
      expect(mail.body.encoded).to match(user.username)
    end
  end
end
