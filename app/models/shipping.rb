class Shipping < ApplicationRecord
  belongs_to :shipping_method
  belongs_to :order
  # TODO: return to belong_to assosiation if required by shipping dashboard
  has_one    :address, class_name: "ShippingAddress"

  validates :shipping_method, presence: true, unless: -> { order.openbasket }
  validates :order, presence: true
  validates :address, presence: true
  validates :pick_up, :drop_off, presence: true
end
