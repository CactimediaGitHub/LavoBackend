class API::Order::OpenBasket::Create
  include ActiveModel::Model
  include API::Concerns::ShippingAddressConcern

  attr_accessor :vendor_id, :customer,
                :shipping, :order

  validates :vendor_id, numericality: { only_integer: true }
  validates :vendor, :customer, presence: true
  validates :shipping, presence: true

  def performed?
    validate &&
    order.save &&
    order.transition_to_pending
  end

  def order
    @order ||=
      ::Order.new(vendor: vendor,
                  customer: customer,
                  shipping: make_shipping,
                  openbasket: true)
  end

  private

  def vendor
    @vendor ||= Vendor.find(vendor_id)
  end
end
