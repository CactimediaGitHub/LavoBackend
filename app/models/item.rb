class Item < ApplicationRecord
  mount_uploader :icon, IconUploader

  has_many :inventory_items
  has_many :services, through: :inventory_items

  validates :name, presence: true

  def to_s
    name
  end
end
