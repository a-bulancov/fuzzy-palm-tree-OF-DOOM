# frozen_string_literal: true

module Api
  module Operations
    module OrderReports
      class Export
        include Dry::Monads[:result, :do]

        def call(id)
          order_report = yield find(id)
          orders = yield fetch_orders_for(order_report)
          csv_file = yield generate_csv(orders)
          yield attach_file(order_report, csv_file)
          Success(order_report)
        end

        private

        def find(id)
          order_report = OrderReport.find(id)
          Success(order_report)
        rescue ActiveRecord::RecordNotFound
          Failure[:order_report_not_found]
        end

        def fetch_orders_for(order_report)
          q = Order.ransack(order_report.payload)
          orders = q.result(distinct: true)
          Success(orders)
        end

        def generate_csv(orders)
          data = orders.map { |order| order.attributes.values }
          headers = ["OrderID", "UserID", "Amount"]
          filename = "report-#{Time.current.strftime("%Y%m%d%H%M%S")}}"
          generator = Utils::CsvGenerator.new(data, headers, filename: filename)
          csv_file = generator.call
          Success(csv_file)
        end

        def attach_file(order_report, csv_file)
          order_report.update!(file: csv_file, status: OrderReport::COMPLETE_STATUS)
          Success(order_report)
        end
      end
    end
  end
end
