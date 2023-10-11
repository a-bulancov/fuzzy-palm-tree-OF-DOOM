# frozen_string_literal: true

class OrdersReportsController < ApplicationController
  before_action :authenticate

  def index
    identifier = SecureRandom.hex
    Orders::FileGeneratorJob.perform_async(order_params.to_hash, identifier)
    render json: { identifier: identifier }, status: :ok
  rescue ArgumentError
    render_bad_request
  end

  def show
    report = Report.find_by(filename: params[:id])
    return head :not_found if report.nil?

    return head :no_content unless report.ready?

    file = Rails.root.join("tmp", "#{@report.filename}.xlsx")
    return head :not_found unless File.exist?(file)

    send_file file, status: :ok
  end

  private

  def order_params
    raise ArgumentError if params[:start_date].blank? || params[:end_date].blank?

    # у меня не получилось установить dry-schema... такой вот странный подход. выглядит страшно
    begin
      Time.parse(params[:start_date])
      Time.parse(params[:end_date])
    rescue ArgumentError => _e
      raise ArgumentError
    end

    params.permit(:start_date, :end_date, :user_name, :sum)
  end

  def render_bad_request
    render json: { "message" => "start_date and end_date parameters are required of format YYYY-MM-DD_HH:mm:ss, " \
                                "optional parameters are user_name:string and sum:float" },
           status: :bad_request
  end
end
