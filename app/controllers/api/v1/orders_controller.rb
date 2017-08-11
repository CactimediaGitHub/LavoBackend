class API::V1::OrdersController < API::V1::VersionController
  before_action :authenticate
  before_action :set_order, :set_includes, only: :show

  def create
    creation =
      API::Order::Create.new(order_params.merge(customer: current_user))
    if creation.performed? && creation.order.valid?
      render json: creation.order,
           status: :created,
          include: [:order_items, :shipping, :address]
    else
      render json: creation.order,
             serializer: ActiveModel::Serializer::ErrorSerializer,
             status: :unprocessable_entity
    end
  end

  def show
    render json: @order, include: @includes
  end

  private

  def order_params
    params.
      require(:order).
      permit(:vendor_id, :adjustable_amount,
             { order_items: %i(inventory_item_id quantity),
             shipping: %i(address_id shipping_method_id pick_up drop_off) }
      )
  end

  def set_order
    @order = current_user.orders.find(params[:id])
  end

  def set_includes
    @includes =
      %i(shipping_method address order_items
         inventory_items customer vendor shipping).tap do |i|
        i.reject! {|sym| sym == current_user.class.name.downcase.to_sym}
      end
  end
end
