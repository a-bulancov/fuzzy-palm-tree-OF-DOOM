class Api::V1::ReportsController < Api::V1::BaseController
  before_action :authenticate_user!

  def generate_report
    prepared_params = prepare_report_params(report_params)

    if prepared_params.failure?
      render_report_errors(prepared_params.errors.to_h)
    else
      perform_report_job
      render_report_success
    end
  end

  private

  def report_params
    params.permit(:username, :from_price, :to_price)
  end

  def perform_report_job
    OrderReportJob.perform_async(@current_user.id, report_params.to_h.symbolize_keys.to_json)
  end

  def prepare_report_params(params)
    validator = CreateReportContract.new
    validator.call(params.to_h)
  end

  def render_report_success
    render json: { message: 'Report will be sent to your email if any data found', status: 'success' }
  end

  def render_report_errors(errors)
    render json: { errors: errors, status: :unprocessable_entity }
  end
end
