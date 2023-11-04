# Preview all emails at http://localhost:3000/rails/mailers/send_csv_mailer
class SendCsvMailerPreview < ActionMailer::Preview
  def send_report
    SendCsvMailer.send_report(User.first, 'test_file_name')
  end
end
