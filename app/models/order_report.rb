# frozen_string_literal: true

class OrderReport < ApplicationRecord
  # has_one_attached :file
  mount_uploader :file, OrderReportUploader

  PROCESSING_STATUS = "processing"
  COMPLETE_STATUS = "complete"

  def complete?
    status == COMPLETE_STATUS
  end
end
