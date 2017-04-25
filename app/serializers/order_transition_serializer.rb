class OrderTransitionSerializer < ActiveModel::Serializer
  attributes :to_state, :metadata, :created_at

  has_one :order
end