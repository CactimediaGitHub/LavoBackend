class ReviewSerializer < ActiveModel::Serializer
  attributes %w(
    rating
    title
    body
    created_at
    comments_count
    likes_count
    liked_by_current_user
  )

  # TODO: cache
  def comments_count
    return 0 unless object.respond_to?(:comments)
    @comments_count ||= object.comments.count
  end

  def likes_count
    # @likes_count ||= Review.where(reviewable: object, rating: 1).count
    @likes_count ||= object.likes.count
  end

  def liked_by_current_user
    object.likes.where(reviewer: current_user).count > 0
  end

  belongs_to :reviewable
  belongs_to :reviewer
  has_many :comments
end