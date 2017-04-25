class ItemType < ApplicationRecord
  has_many :inventory_items
  has_many :services, through: :inventory_items
  has_many :items, through: :inventory_items

  validates :name, presence: true

  def to_s
    name
  end
end
