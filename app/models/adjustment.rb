class Adjustment < ApplicationRecord
  with_options polymorphic: true do
    belongs_to :adjustable, touch: true
    belongs_to :source
  end
  belongs_to :order, inverse_of: :all_adjustments

  validates :adjustable, :order, presence: true
  validates :label, presence: true, allow_blank: true
  validates :amount, numericality: true

end