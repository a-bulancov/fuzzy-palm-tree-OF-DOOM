require 'swagger_helper'

RSpec.describe 'api/admins/order_reports', type: :request do

  path '/api/admins/order_reports/{id}/export' do
    # You'll want to customize the parameter types...
    parameter name: 'id', in: :path, type: :integer, description: 'order report id'

    post('export order_report') do
      response(200, 'successful') do
        let!(:order_report) { create(:order_report, status: "complete") }
        let!(:id) { order_report.id }
        run_test!
      end

      response(400, 'not complete yet') do
        let!(:order_report) { create(:order_report, status: "processing") }
        let!(:id) { order_report.id }
        run_test!
      end
    end
  end

  path '/api/admins/order_reports' do

    post('create order_report') do
      consumes 'application/json'
      produces 'application/json'

      response(200, 'successful') do
        parameter name: :q, in: :body, description: 'query object',
          schema: {
            type: :object,
            properties: {
              user_id_in: {
                type: :array,
                items: {
                  type: :integer
                }
              },
              amount_eq: {
                type: :integer
              },
              amount_gteq: {
                type: :integer
              },
              amount_lteq: {
                type: :integer
              },
              amount_gt: {
                type: :integer
              },
              amount_lt: {
                type: :integer
              }
            }
          }
        let!(:q) { { q: {user_id_in: [1, 2, 3]} } }
        run_test!
      end

      response(400, 'validation error') do
        parameter name: :q, in: :body, description: 'query object',
          schema: {
            type: :object,
            properties: {
              user_id_in: {
                type: :array,
                items: {
                  type: :integer
                }
              },
              amount_eq: {
                type: :integer
              },
              amount_gteq: {
                type: :integer
              },
              amount_lteq: {
                type: :integer
              },
              amount_gt: {
                type: :integer
              },
              amount_lt: {
                type: :integer
              }
            }
          }
        let!(:q) { { q: {user_id_in: []} } }
        run_test!
      end
    end
  end
end
