require 'active_support/concern'
require 'review'

module ReviewExtention
  extend ActiveSupport::Concern

  included do
    has_many :comments,
             -> { order(:id) },
             foreign_key: :reviewable_id,
             foreign_type: 'Review',
             class_name: 'Comment'

    has_many :likes,
             foreign_key: :reviewable_id,
             foreign_type: 'Review',
             class_name: 'Like'

    scope :all_reviews, -> {
           of_reviewable_type(Vendor).
           by_reviewer_type(Customer).
           with_a_body }
  end
end

Review.send(:include, ReviewExtention)
