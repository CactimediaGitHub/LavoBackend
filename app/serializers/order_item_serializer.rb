class OrderItemSerializer < ActiveModel::Serializer
  attributes %i(quantity)

  belongs_to :order
  belongs_to :inventory_item
end
