require 'csv'

class OrderReportJob
  include Sidekiq::Worker
  queue_as :default

  def perform(user_id, args_json)
    args_hash = JSON.parse(args_json).symbolize_keys
    send_report(user_id, args_hash)
  end

  private

  def send_report(user_id, args_hash)
    file_path = Rails.root.join('tmp', 'orders_report.csv')
    find_orders(args_hash).to_csv(file_path)

    SendCsvMailer.send_report(user_id, file_path).deliver_now
  end

  def find_orders(args_hash)
    FindOrders.new(Order.all).call(args_hash)
  end
end
