# frozen_string_literal: true

module Api
  module Operations
    module OrderReports
      class Create
        include Dry::Monads[:result, :do]

        def call(params)
          validated_params = yield validate(params)
          order_report = yield create(validated_params.to_h)
          enqueue(order_report)
          Success(order_report)
        end

        private

        def validate(params)
          validation = Api::Validations::OrderReports::Create.new
          validation.call(params)
            .to_monad
            .fmap { |r| r }
            .or { |r| Failure[:validation_error, r.errors.to_h]}
        end

        def create(params)
          order_report = OrderReport.create!(
            status: OrderReport::PROCESSING_STATUS,
            payload: params
          )
          Success(order_report)
        end

        def enqueue(order_report)
          OrderReportsExportJob.perform_later(order_report.id)
        end
      end
    end
  end
end
