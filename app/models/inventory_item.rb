class InventoryItem < ApplicationRecord
  include FilterablePgSearchScope

  has_many :order_item

  belongs_to :item
  belongs_to :item_type
  belongs_to :service
  belongs_to :vendor

  validates :item, presence: true
  validates :item_type, presence: true
  validates :service, presence: true
  validates :vendor, presence: true

  validates_uniqueness_of :item_id,
                     scope: [:vendor_id, :service_id, :item_type_id],
                   message: :exists
  validates :price, numericality: { greater_than: 0, only_integer: true }

  pg_search_scope(:search,
    associated_against: {
      item: [:name],
      item_type: [:name],
      service: [:name],
      vendor: [:name],
    },
  )
end
