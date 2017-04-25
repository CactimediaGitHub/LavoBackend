class NotificationSerializer < ActiveModel::Serializer
  type 'notification_messages'
  attributes %i(message created_at order_id)
end