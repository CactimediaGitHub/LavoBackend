class API::V1::Pushes::NotificationMessagesController < API::V1::VersionController
  before_action :authenticate

  def index
    index = ::Index::NotificationsIndex.new(self)
    notifications = index.notifications(current_user.notifications)
    render json: notifications, meta: pagination(notifications)
  end

  def create
    response = API::V1::Pushes::CreateNotification.new(notification_attributes).deliver

    if response[:status_code] == 200
      save_notification(notification_attributes)
      render json: response[:body], status: 200
    else
      render json: response[:body], status: :unprocessable_entity
    end
  end

  private

  def notification_params
    params.fetch(:data, {}).permit(:type, {
      attributes: [{ tokens: [] }, :message, :title]
    })
  end

  def notification_attributes
    notification_params.fetch(:attributes, {})
  end

  def save_notification(attrs={})
    attributes = attrs.except(:tokens, :title).merge(notifiable: current_user)
    notification = Notification.create(attributes)
    Rails.logger.tagged('push save') do
      Rails.logger.info(notification.errors.to_a.join(', '))
    end if notification.errors.present?
  end
end