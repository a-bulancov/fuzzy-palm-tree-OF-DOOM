class Orders::FileGeneratorJob
  include Sidekiq::Job

  # maybe it's better to call query object and create report here
  def perform(order_params, identifier)
    orders = Orders::IndexQuery.call(order_params)
    report = Report.create(filename: identifier)
    Axlsx::Package.new do |package|
      headers = Order.first&.serialize&.keys
      package.workbook.add_worksheet(name: "orders") do |sheet|
        sheet.add_row headers
        orders.each { |order| sheet.add_row order.serialize.values }
      end
      package.serialize(Rails.root.join("tmp", "#{identifier}.xlsx"))
    end
    report.update(ready: true)
  end
end
