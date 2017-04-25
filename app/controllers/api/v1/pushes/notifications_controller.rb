class API::V1::Pushes::NotificationsController < API::V1::VersionController
  before_action :authenticate

  def index
    index = ::Index::NotificationIndex.new(self)
    notifications = index.notifications(current_user.notifications)
    render json: notifications, meta: pagination(notifications)
  end

end