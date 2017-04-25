class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :inventory_item
  delegate :price, to: :inventory_item

  validates :order, presence: true
  validates :inventory_item, presence: true

  validates :quantity, numericality: { greater_than: 0, only_integer: true }

  def total
    self.price * self.quantity
  end
end
