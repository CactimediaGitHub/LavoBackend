class ShippingAddressSerializer < ActiveModel::Serializer
  attributes ShippingAddress.permitted_attributes

  belongs_to :shipping
end