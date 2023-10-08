class DownloadsController < ApplicationController
  before_action :authenticate
  before_action :find_report


  def show
    file = File.join(Rails.root, "tmp", "#{@report.filename}.xlsx")
    return head :not_found if !File.exists?(file)

    send_file file, status: :ok
  end

  private

  def find_report
    @report = Report.find_by(filename: params[:id])
    return head :not_found if @report.nil?
    return head :no_content if !@report.ready?
  end
end
