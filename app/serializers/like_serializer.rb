class LikeSerializer < ActiveModel::Serializer
  type 'likes'
  attributes %w(
    reviewable_type
    reviewable_id
    reviewer_type
    reviewer_id
    rating
  )

  belongs_to :reviewable, serializer: ReviewSerializer
  belongs_to :reviewer,   serializer: CustomerSerializer
end