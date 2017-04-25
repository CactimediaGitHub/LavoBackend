class API::Order::OpenBasket::Update
  include ActiveModel::Model

  attr_accessor :order_items, :shipping, :order

  validates :order_items, :shipping, presence: true

  def performed?
    validate &&
    order_update
  end

  def order_update
    ::ActiveRecord::Base.transaction do
      order.state_machine.transition_to(:approving) #&&
      order.update(
        order_items: order_items.map { |i| OrderItem.new(i) },
        shipping: updated_shipping
      )
    end
  end

  private

  def updated_shipping
    order.shipping.shipping_method_id = shipping['shipping_method_id']
    order.shipping
  end
end
