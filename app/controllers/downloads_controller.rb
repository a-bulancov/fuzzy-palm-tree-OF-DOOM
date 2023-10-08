class DownloadsController < ApplicationController
  before_action :authenticate


  def show
    filename = params[:filename]
  end
end
