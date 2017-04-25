class OrderSerializer < ActiveModel::Serializer
  attributes %i(total subtotal promotion_amount state openbasket created_at updated_at)

  belongs_to :vendor
  belongs_to :customer

  has_one :shipping
  has_one :shipping_method
  has_one :address
  has_many :order_items
  has_many :inventory_items
end
