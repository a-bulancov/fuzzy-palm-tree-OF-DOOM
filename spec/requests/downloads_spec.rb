require "rails_helper"
require 'sidekiq/testing'
Sidekiq::Testing.fake!

RSpec.describe "Download requests", type: :request do
  let(:identifier) { response.body["identifier"] }
  let(:token) { create(:token) }

  context "when requesting nonexistent report" do
    it "returns :not_found" do
      get "/downloads/abc", headers: { "Authentication" => "Bearer #{token.value}" }
      expect(response).to have_http_status(:not_found)
    end
  end

  # ???????
  context "when requesting a file that has not been compiled yet" do
    it "return :no_content" do
      get "/orders", params: { start_date: "2017-10-08_23:12:24", end_date: "2024-10-09_03:12:39" },
                   headers: { "Authentication" => "Bearer #{token.value}" }
      get "/downloads/#{identifier}", headers: { "Authentication" => "Bearer #{token.value}" }
    end
  end
end
