class SendCsvMailer < ApplicationMailer
  def send_report(user_id, filename)
    attachments['orders_report.csv'] = { mime_type: 'text/csv', content: filename }
    @user = User.find_by(id: user_id)

    mail(to: @user.email, subject: "CSV orders report for #{@user.username}")
  end
end
