# frozen_string_literal: true

module Api
  module Admins
    class BaseController < ApplicationController
      include Dry::Monads[:result]
      before_action :authenticate_admin!

      private

      def authenticate_admin!
        header = request.headers["Authorization"]
      end
    end
  end
end
