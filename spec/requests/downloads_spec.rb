require "rails_helper"
require 'sidekiq/testing'
Sidekiq::Testing.fake!

RSpec.describe "Download requests", type: :request do
  let(:identifier) { JSON.parse(response.body)["identifier"] }
  let(:token) { create(:token) }
  let(:date_params) { { start_date: "2017-10-08_23:12:24", end_date: "2024-10-09_03:12:39" } }
  let(:auth_headers) { { "Authentication" => "Bearer #{token.value}" } }

  context "when requesting nonexistent report" do
    it "returns :not_found" do
      get "/downloads/abc", headers: auth_headers
      expect(response).to have_http_status(:not_found)
    end
  end

  context "when requesting a file that has not been created yet" do
    it "return :no_content" do
      get "/orders", params: date_params, headers: auth_headers
      get "/downloads/#{identifier}", headers: auth_headers
      expect(response).to have_http_status(:no_content)
    end
  end

  # how to test this
  xcontext "when requesting with correct indetifier" do
    Sidekiq::Testing.inline!

    it "sends a file" do
      get "/orders", params: date_params, headers: auth_headers
      get "/downloads/#{identifier}", headers: auth_headers
      expect(response).to have_http_status(:ok)
    end
  end
end
