class TokensController < ApplicationController
  def new
    token = Token.create(value: SecureRandom.hex, expires: 1.hour.from_now)
    response.set_header("Authentication", "Bearer #{token.value}")

    head :ok
  end
end
