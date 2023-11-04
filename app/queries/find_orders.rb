class FindOrders
  attr_accessor :initial_scope

  def initialize(initial_scope)
    @initial_scope = initial_scope
  end

  def call(params)
    scoped = filter_by_price(initial_scope, params[:from_price], params[:to_price])
    filter_by_user_id(scoped, params[:user_id])
  end

  private

  def filter_by_price(scoped, from_price = nil, to_price = nil)
    from_price ? scoped.where('price >= ?', from_price.to_f) : scoped
    to_price ? scoped.where('price <= ?', to_price.to_f) : scoped
  end

  def filter_by_user_id(scoped, user_id = nil)
    user_id ? scoped.where(user_id: user_id) : scoped
  end
end
