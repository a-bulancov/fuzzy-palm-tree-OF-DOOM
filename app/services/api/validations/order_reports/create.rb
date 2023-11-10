# frozen_string_literal: true

module Api
  module Validations
    module OrderReports
      class Create < Dry::Validation::Contract
        params do
          optional(:user_id_in).filled(:array)
          optional(:amount_eq).filled(:integer)
          optional(:amount_lt).filled(:integer)
          optional(:amount_lteq).filled(:integer)
          optional(:amount_gt).filled(:integer)
          optional(:amount_gteq).filled(:integer)
        end

        rule do
          if values[:user_id_in].nil? && values[:amount_eq].nil?
            key(:user_id_in_or_amount_eq)
              .failure("must at least contain one of: user_id_in, amount_eq")
          end
        end
      end
    end
  end
end
