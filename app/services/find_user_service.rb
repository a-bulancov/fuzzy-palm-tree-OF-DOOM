class FindUserService
  def initialize(token)
    @token = token
  end

  def fetch_user_id
    # TODO: Implement find user by token
    User.first.id
  end
end
