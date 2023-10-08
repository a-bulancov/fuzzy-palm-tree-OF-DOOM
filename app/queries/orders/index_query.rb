class Orders::IndexQuery
  def self.call(order_params)
    start_date = DateTime.parse(order_params[:start_date])
    end_date = DateTime.parse(order_params[:end_date])
    user_id = User.where(name: order_params[:user_name]) if order_params[:user_name].present?
    scope = Order.where("ordered_at between ? and ?", start_date, end_date)
    scope = scope.where(user_id: user_id) if order_params[:user_name].present?
    scope = scope.where(sum: order_params[:sum]) if order_params[:sum].present?
    scope
  end
end
