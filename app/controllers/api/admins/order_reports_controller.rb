# frozen_string_literal: true

module Api
  module Admins
    class OrderReportsController < BaseController
      def create
        operation = Operations::OrderReports::Create.new
        result = operation.call(order_report_params.to_h)

        case result
        in Success[order_report]
          render json: {success: true, order_report_id: order_report.id}
        in Failure[error_code, error_description]
          render json: {success: false, error_code: error_code, error_description: error_description}, status: :bad_request
        end
      end

      def export
        order_report = OrderReport.find(params[:id])

        if order_report.complete?
          send_data order_report.file.path
        else
          render json: {success: false, error_description: "Not complete yet"}, status: :bad_request
        end
      end

      private

      def order_report_params
        params.require(:q).permit(
          :amount_eq,
          :amount_gteq,
          :amount_lteq,
          :amount_gt,
          :amount_lt,
          user_id_in: []
        )
      end
    end
  end
end

