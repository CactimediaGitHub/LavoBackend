class ShippingMethod < ApplicationRecord
  include FilterablePgSearchScope

  has_many :shippings
  belongs_to :vendor
  belongs_to :shipping_method_name

  validates :vendor, presence: true
  validates :delivery_period,
            numericality: { greater_than: 0, only_integer: true }

  # enum shipping_method: { normal: 'normal', express: 'express' }
  # validates :shipping_method,
  #   uniqueness: { scope: :vendor_id, message: :exists },
  #    inclusion: { in: self.shipping_methods.keys }

  validates :shipping_method_name_id, uniqueness: {
    scope: :vendor_id, message: :exists
  }

  pg_search_scope(:search,
    associated_against: {
      vendor: [:name],
      shipping_method_name: [:name]
    },
  )
end
