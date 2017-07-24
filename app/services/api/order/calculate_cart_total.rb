class API::Order::CalculateCartTotal
  include ActiveModel::Model
  include ActiveModel::Serialization

  attr_accessor :order_items, :shipping, :promotion_amount
  attr_reader :total, :subtotal, :id

  validates :shipping, presence: true
  # validates :subtotal, :total, numericality: { greater_than: 0 }

  def promotion_amount
    @promotion_amount ||= cart_calculator.promotion_amount
  end

  private

  def cart_calculator
    @cart_calculator ||=
      API::Order::CartCalculator.new(order_items: order_items, shipping: shipping)
  end

  def total
    @total ||= cart_calculator.total
  end

  def subtotal
    @subtotal ||=cart_calculator.subtotal
  end

end
