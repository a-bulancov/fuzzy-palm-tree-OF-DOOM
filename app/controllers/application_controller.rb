class ApplicationController < ActionController::Base
  private

  def authenticate
    header = request.headers["Authentication"]
    token_value = header&.split&.second
    token = Token.find_by(value: token_value)
    head :forbidden if token.blank? || token.expired?
  end
end
