class InventoryItemSerializer < ActiveModel::Serializer
  attributes :id, :price

  has_one :vendor
  has_one :service
  has_one :item
  has_one :item_type
end