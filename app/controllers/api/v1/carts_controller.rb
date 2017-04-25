class API::V1::CartsController < API::V1::VersionController

  before_action :authenticate

  def create
    calculation = API::Order::CalculateCartTotal.new(cart_params)
    if calculation.valid?
      render json: calculation, status: 200
    else
      render json: calculation,
             serializer: ActiveModel::Serializer::ErrorSerializer,
             status: :unprocessable_entity
    end
  end

  private

  def cart_params
    params.
      require(:order).
      permit({ order_items: %i(inventory_item_id quantity),
               shipping: %i(shipping_method_id)
    })
  end

  def order_items
    cart_params[:order_items] || {}
  end
end
