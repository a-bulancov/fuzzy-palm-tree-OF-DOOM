# frozen_string_literal: true

class OrderReportsExportJob < ApplicationJob
  queue_as :reports

  def perform(order_id)
    operation = Operations::OrderReports::Export.new
    operation.call(order_id)
  end
end
