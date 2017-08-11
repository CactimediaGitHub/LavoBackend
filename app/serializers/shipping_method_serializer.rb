class ShippingMethodSerializer < ActiveModel::Serializer
  attributes :id, :shipping_charge_percent, :shipping_method, :delivery_period

  has_one :vendor
  # belongs_to :shipping_method_name

  def shipping_method
    object.shipping_method_name.name
  end
end
