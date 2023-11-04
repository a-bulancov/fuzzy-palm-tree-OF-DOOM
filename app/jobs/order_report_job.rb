require 'csv'

class OrderReportJob
  include Sidekiq::Worker
  queue_as :default

  def perform(args)
    args_hash = JSON.parse(args).symbolize_keys
    user = User.find_by(username: args_hash[:username])
    orders = FindOrders.new(Order.all).call(args_hash.merge(user_id: user.id))

    return unless user

    orders_csv = orders.to_csv
    SendCsvMailer.send_report(user.id, orders_csv).deliver_now
  end
end
