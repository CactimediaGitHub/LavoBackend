class API::V1::Vendor::OrdersController < API::V1::VersionController
  before_action :authenticate

  # TODO: move to orders controller
  def index
    orders_index = ::Index::OrdersIndex.new(self)
    orders = orders_index.orders(current_user.orders)
    render json: orders,
           meta: meta(orders),
           include: :customer
  end

  private

  def meta(orders)
    pagination(orders).
    merge(orders_by_states_count(current_user))
  end
end
