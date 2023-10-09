class Orders::FileGeneratorWorker
  include Sidekiq::Worker

  def perform(order_ids, filename, report_id)
    orders = Order.where(id: order_ids)
    Axlsx::Package.new do |package|
      package.workbook.add_worksheet(name: "orders") do |sheet|
        sheet.add_row Order.column_names
        orders.each { |order| sheet.add_row order.serialize }
      end
      package.serialize("tmp/#{filename}.xlsx")
    end
    Report.find(report_id).update(ready: true)
  end
end
