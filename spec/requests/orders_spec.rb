require "rails_helper"
require 'sidekiq/testing'
Sidekiq::Testing.fake!

RSpec.describe "Order requests", type: :request do
  let(:token) { create(:token) }
  let(:users) { { john_cena: create(:john_cena), razrushitel: create(:razrushitel), unnamed: create(:unnamed) } }
  let(:filtered_by_name) { Order.create(user: users[:john_cena], sum: 205.30, ordered_at: "2018-10-08 23:12:24") }
  let(:filtered_by_sum) { Order.create(user: users[:razrushitel], sum: 1000.0, ordered_at: "2023-10-09 02:12:39") }
  let(:filtered_by_date) { Order.create(user: users[:unnamed], sum: 80.55, ordered_at: "2023-10-09 03:12:39") }
  let(:auth_headers) { { "Authentication" => "Bearer #{token.value}" } }
  let(:date_params) { { start_date: "2017-10-08_23:12:24", end_date: "2024-10-09_03:12:39" } }

  context "when requesting with invalid token" do
    it "returns :forbidden" do
      get "/orders", headers: { "Authentication" => "Bearer #{create(:expired_token).value}" }
      expect(response).to have_http_status(:forbidden)

      get "/orders", headers: { "Authentication" => "Bearer abc" }
      expect(response).to have_http_status(:forbidden)
    end
  end

  context "when requesting without required parameters" do
    it "returns :bad_request" do
      get "/orders", params: { start_date: Time.now.to_s }, headers: auth_headers
      expect(response).to have_http_status(:bad_request)
    end
  end

  context "when request params are of invalid format" do
    it "returns :bad_request" do
      get "/orders", params: { start_date: "abc", end_date: "def" }, headers: auth_headers
      expect(response).to have_http_status(:bad_request)
    end
  end

  context "when supplying sum filter" do
    it "creates a file generator worker with filtered order" do
      expect(Orders::FileGeneratorWorker).to receive(:perform_async).with([filtered_by_sum.id], anything, anything)
      get "/orders", params: date_params.merge({ sum: "1000.0" }), headers: auth_headers
      expect(response).to have_http_status(:ok)
    end
  end

  context "when supplying name filter" do
    it "creates a file generator worker with filtered order" do
      expect(Orders::FileGeneratorWorker).to receive(:perform_async).with([filtered_by_name.id], anything, anything)
      get "/orders", params: date_params.merge({ user_name: "john cena" }), headers: auth_headers
      expect(response).to have_http_status(:ok)
    end
  end

  context "when supplying time filter" do
    it "creates a file generator worker with filtered order" do
      expect(Orders::FileGeneratorWorker).to receive(:perform_async).with([filtered_by_date.id], anything, anything)
      get "/orders", params: { start_date: "2023-10-09 03:00:00", end_date: "2023-10-09 04:00:00" },
                     headers: auth_headers
      expect(response).to have_http_status(:ok)
    end
  end

  context "when supplying correct params" do
    it "create a file generator worker" do
      expect(Orders::FileGeneratorWorker).to receive(:perform_async).with(Order.all.pluck(:id), anything, anything)
      get "/orders", params: date_params, headers: auth_headers
      expect(response).to have_http_status(:ok)
    end
  end
end
