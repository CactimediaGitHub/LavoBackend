class Comment < ApplicationRecord
  self.table_name = :reviews

  default_scope do
    Review.of_reviewable_type(Review).
    with_a_body
  end

  validates :body, presence: true

  belongs_to :reviewable, polymorphic: true
  belongs_to :reviewer,   polymorphic: true
end
