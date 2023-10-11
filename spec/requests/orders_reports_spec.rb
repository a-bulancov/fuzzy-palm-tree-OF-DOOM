# frozen_string_literal: true

RSpec.describe "Orders and reports requests", type: :request do
  def job_params
    [yield, anything]
  end

  let(:token) { create(:token) }
  let(:identifier) { JSON.parse(response.body)["identifier"] }
  let(:auth_headers) { { "Authentication" => "Bearer #{token.value}" } }
  let(:date_params) { { "start_date" => "2017-10-08_23:12:24", "end_date" => "2024-10-09_03:12:39" } }

  context "when requesting with invalid token" do
    it "returns :forbidden" do
      get "/orders_reports", headers: { "Authentication" => "Bearer #{create(:expired_token).value}" }
      expect(response).to have_http_status(:forbidden)

      get "/orders_reports", headers: { "Authentication" => "Bearer abc" }
      expect(response).to have_http_status(:forbidden)
    end
  end

  context "when requesting without required parameters" do
    it "returns :bad_request" do
      get "/orders_reports", params: { start_date: Time.current.to_s }, headers: auth_headers
      expect(response).to have_http_status(:bad_request)
    end
  end

  context "when request params are of invalid format" do
    it "returns :bad_request" do
      get "/orders_reports", params: { start_date: "abc", end_date: "def" }, headers: auth_headers
      expect(response).to have_http_status(:bad_request)
    end
  end

  context "when supplying correct params" do
    it "create a file generator worker" do
      expect(Orders::FileGeneratorJob).to receive(:perform_async).with(*job_params { date_params })
      get "/orders_reports", params: date_params, headers: auth_headers
      expect(response).to have_http_status(:ok)
    end
  end

  context "when requesting nonexistent report" do
    it "returns :not_found" do
      get "/orders_reports", params: date_params, headers: auth_headers
      get "/orders_reports/abc", headers: auth_headers
      expect(response).to have_http_status(:not_found)
    end
  end

  # если создавать репорт внутри воркера то это тоже не получается протестить.. поэтому сделал в контроллере
  # наверно стоит добавить возможность вставлять блок внутрь воркера чтобы его замедлить в промежутке между
  # созданием файла и обработкой
  xcontext "when requesting a file that has not been created yet" do
    it "return :no_content" do
      get "/orders_reports", params: date_params, headers: auth_headers
      get "/orders_reports/#{identifier}", headers: auth_headers
      expect(response).to have_http_status(:no_content)
    end
  end

  # how to test this
  xcontext "when requesting with correct indetifier" do
    it "sends a file" do
      get "/orders_reports", params: date_params, headers: auth_headers
      get "/orders_reports/#{identifier}", headers: auth_headers
      expect(response).to have_http_status(:ok)
    end
  end
end
