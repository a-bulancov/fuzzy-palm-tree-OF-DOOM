class DownloadsController < ApplicationController
  before_action :authenticate
  before_action :find_report

  def show
    file = File.join(Rails.root, "tmp", "#{@report.filename}.xlsx")
    return head :not_found unless File.exist?(file)

    send_file file, status: :ok
  end

  private

  def find_report
    @report = Report.find_by(filename: params[:id])
    return head :not_found if @report.nil?

    head :no_content unless @report.ready?
  end
end
