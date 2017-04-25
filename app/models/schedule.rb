class Schedule < ApplicationRecord
  include FilterablePgSearchScope

  belongs_to :vendor
  validates :vendor, presence: true
  validates :weekday, presence: true, inclusion: { in: Date::DAYNAMES }
  validates :weekday, uniqueness: { scope: :vendor_id }

  pg_search_scope(:search,
    against: [:weekday],
    associated_against: {
      vendor: [:name],
    },
  )
end
