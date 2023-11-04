class Api::V1::ReportsController < Api::V1::BaseController
  before_action :authenticate_user!

  def generate_report
    prepaired_params = prepare_report_params(report_params)

    if prepaired_params.failure?
      render json: { errors: prepaired_params.errors.to_h }, status: :unprocessable_entity
    else
      OrderReportJob.perform_async(@current_user.id, report_params.to_h.symbolize_keys.to_json)
      render json: { message: 'Report will be sent to your email if any data found', status: 'success' }
    end
  end

  private

  def report_params
    params.permit(:username, :from_price, :to_price)
  end

  def prepare_report_params(params)
    validator = CreateReportContract.new
    validator.call(params.to_h)
  end
end
