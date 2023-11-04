require 'csv'

class OrderReportJob
  include Sidekiq::Worker
  queue_as :default

  def perform(user_id, args)
    args_hash = JSON.parse(args).symbolize_keys

    orders = FindOrders.new(Order.all).call(args_hash)
    orders_csv = orders.to_csv
    SendCsvMailer.send_report(user_id, orders_csv).deliver_now
  end
end
