class API::Order::Create
  include ActiveModel::Model
  include API::Concerns::ShippingAddressConcern

  attr_accessor :vendor_id, :customer, :adjustable_amount,
                :order_items, :shipping, :order

  validates :vendor_id, numericality: { only_integer: true }
  validates :vendor, :customer, presence: true
  validates :order_items, :shipping, presence: true

  def performed?
    validate &&
    # FIXME: use ! version of save and others..
    ::ActiveRecord::Base.transaction do
      order.save
      PromotionHandler::Cart.new(order).activate
    end
  end

  def order
    # FIXME: use block Order.new do |o|
    @order ||=
      ::Order.new(vendor: vendor,
                  adjustable_amount: adjustable_amount,
                  customer: customer,
                  order_items: order_items.map { |i| OrderItem.new(i) },
                  shipping: make_shipping,
                  total: total,
                  subtotal: subtotal,
                  promotion_amount: promotion_amount,
                  shipping_amount: shipping_amount)
  end

  private

  def vendor
    @vendor ||= Vendor.find(vendor_id)
  end

  # NOTE subtotal + shipping - promotion_amount
  def total
    cart_calculator.total
  end

  def promotion_amount
    cart_calculator.promotion_amount
  end

  def shipping_amount
    cart_calculator.shipping_amount
  end

  def subtotal
    cart_calculator.subtotal
  end

  private

  def cart_calculator
    @cart_calculator ||= API::Order::CartCalculator.new(order_items: order_items, shipping: shipping, vendor_id: vendor_id)
  end
end
