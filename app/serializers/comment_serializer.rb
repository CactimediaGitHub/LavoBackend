class CommentSerializer < ActiveModel::Serializer
  type 'comments'
  attributes %w(
    reviewer_id
    reviewer_type
    reviewer_name
    reviewer_avatar
    body
    created_at
    updated_at
  )
  belongs_to :reviewable

  def reviewer_name
    object.reviewer&.full_name
  end

  def reviewer_avatar
    object.reviewer&.avatar&.url
  end
end
