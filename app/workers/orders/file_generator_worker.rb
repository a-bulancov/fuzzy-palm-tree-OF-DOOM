class Orders::FileGeneratorWorker
  include Sidekiq::Worker

  def perform(order_ids, filename)
    report = Report.create(filename: filename)
    orders = Order.where(id: order_ids)
    Axlsx::Package.new do |package|
      package.workbook.add_worksheet(name: "orders") do |sheet|
        sheet.add_row Order.column_names
        orders.each { |order| sheet.add_row order.serialize }
      end
      package.serialize("tmp/#{filename}.xlsx")
    end
    report.update(ready: true)
  end
end
