require 'active_support/concern'

module API::Concerns::ShippingAddressConcern
  extend ActiveSupport::Concern

  private

  def make_shipping
    address_id = shipping.delete(:address_id)
    customer_address = customer.addresses.find(address_id)
    shipping_address =
      ShippingAddress.new(customer_address.attributes.except('customer_id', 'id', 'created_at', 'updated_at'))
    Shipping.new(shipping) do |s|
      s.address = shipping_address
    end
  end

end
