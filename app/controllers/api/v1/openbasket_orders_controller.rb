class API::V1::OpenbasketOrdersController < API::V1::VersionController
  before_action :authenticate
  before_action :set_order, only: :update

  def create
    creation =
      API::Order::OpenBasket::Create.new(order_params.merge(customer: current_user))

    if creation.performed?
      render json: creation.order,
           status: :created,
          include: [:order_items, :shipping, :address]
    else
      render json: creation.order,
       serializer: ActiveModel::Serializer::ErrorSerializer,
           status: :unprocessable_entity
    end
  end

  def update
    update =
      API::Order::OpenBasket::Update.new(order_params.merge(order: @order))

    if update.performed?
      render json: update.order,
           status: 200,
          include: [:order_items, :shipping]
    else
      render json: update.order,
       serializer: ActiveModel::Serializer::ErrorSerializer,
           status: :unprocessable_entity
    end

  end

  private

  def order_params
    params.
      require(:order).
      permit(
        :vendor_id,
        { order_items: %i(inventory_item_id quantity),
          shipping: %i(address_id shipping_method_id pick_up drop_off) }
      )
  end

  def set_order
    @order = current_user.orders.find(params[:id])
  end
end
