class API::Order::CalculateCartTotalSerializer < ActiveModel::Serializer

  attributes %i(order_items shipping promotion_amount)

  attribute :subtotal, if: -> { object.order_items.present? && object.shipping.present?}
  attribute :total, if: -> { object.order_items.present? && object.shipping.present?}
end
