class Like < ApplicationRecord
  self.table_name = :reviews

  default_scope do
    where(reviewable_type: 'Review').
    where(rating: 1.0)
  end

  belongs_to :reviewable, polymorphic: true
  belongs_to :reviewer,   polymorphic: true

  validates :reviewable, :reviewer, presence: true

  validates :rating, inclusion: { in: [1.0] }
  validates :reviewable_type, inclusion: { in: ['Review'] }
end
