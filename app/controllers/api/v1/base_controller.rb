class Api::V1::BaseController < ApplicationController
  private

  def authenticate_user!
    return unless request.headers['Authorization'].present?

    token = request.headers['Authorization'].split.try(:last)

    user_id = FindUserService.new(token).fetch_user_id.try(:to_i)

    if user_id.nil?
      render json: { error: 'Invalid token' }, status: 401
    else
      @current_user = User.find(user_id)
    end
  end
end
