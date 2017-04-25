class AddressSerializer < ActiveModel::Serializer
  attributes Address.permitted_attributes

  has_one :customer
end