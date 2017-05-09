class Holiday < ApplicationRecord
  belongs_to :vendor

  validates :holiday_date, presence: true
end
