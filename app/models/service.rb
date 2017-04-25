class Service < ApplicationRecord
  has_many :inventory_items
  has_many :items, through: :inventory_items

  validates :name, presence: true

  def to_s
    name
  end
end
