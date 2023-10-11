class TokensController < ApplicationController
  def new
    token = Token.create(value: SecureRandom.hex, expires: 1.hour.from_now)

    render json: { access_token: token.value, token_type: "bearer", expires_in: 3600 }
  end
end
