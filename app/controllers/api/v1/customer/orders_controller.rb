class API::V1::Customer::OrdersController < API::V1::VersionController

  before_action :authenticate

  def index
    orders_index = ::Index::OrdersIndex.new(self)
    orders = orders_index.orders(current_user.orders)
    render json: orders,
           meta: meta(orders),
           include: :vendor
  end

  private

  def meta(orders)
    Rails.logger.ap(orders_by_states_count(current_user), :info) unless Rails.env.production?
    pagination(orders).merge(orders_by_states_count(current_user))
  end
end