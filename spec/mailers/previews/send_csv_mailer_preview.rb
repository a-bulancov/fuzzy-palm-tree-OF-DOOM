# Preview all emails at http://localhost:3000/rails/mailers/send_csv_mailer
class SendCsvMailerPreview < ActionMailer::Preview
  def send_report
    content = "id,order_date,price,user_id\n1,2023-11-03 09:54:33 UTC,10.1,1\n2,2023-11-02 09:54:33 UTC,20.2,1\n3,2023-11-04 00:00:00 UTC,30.2,1"
    SendCsvMailer.send_report(User.first, content)
  end
end
