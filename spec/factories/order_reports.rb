# frozen_string_literal: true

FactoryBot.define do
  factory :order_report do
    status { "processing" }
    file { Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/files/order_report.csv")) }
    payload { {"user_id_in" => [1, 2, 3]} }
  end
end
