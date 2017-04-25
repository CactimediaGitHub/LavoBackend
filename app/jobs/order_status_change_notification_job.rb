class OrderStatusChangeNotificationJob < ApplicationJob
  queue_as :default

  def perform(*args)
    args = args.first

    order = Order.find args[:order_id]
    title = 'Your Lavo order state changed'
    message = "Order ##{order.id}: state changed to '#{order.state}'"

    response = API::V1::Pushes::CreateNotification.new(
      tokens: tokens(order, args),
      message: message,
      title: title,
    ).deliver

    Rails.logger.tagged("job for order ##{order.id} status change done") do
      Rails.logger.info(response.to_s)
    end
  end

  private

  def tokens(order, args)
    @tokens ||=
      args[:notify].flat_map do |user|
        order.send(user.to_sym).notification_registrations.pluck(:token)
      end
  end

end
