require 'rails_helper'

RSpec.describe Api::V1::ReportsController, type: :controller do
  let!(:user) { create(:user, username: 'example_user') }

  describe 'POST #generate_report' do
    context 'with valid parameters' do
      let(:valid_params) { { "username" => 'example_user', "from_price" => "10.0", "to_price" => "50.0" } }

      it 'enqueues a job and returns a success message' do
        request.headers.merge!({'Authorization': 'test_token'})
        expect(CreateReportContract).to receive(:new).and_return(contract_double = double)
        expect(contract_double).to receive(:call).with(valid_params).and_return(ValidationResult.new)
        expect(OrderReportJob).to receive(:perform_async)

        post :generate_report, params: valid_params, format: :json

        expect(response).to have_http_status(:success)
        expect(response.body).to include('Report will be sent to your email')
      end
    end
  end
end
