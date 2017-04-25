module Index
  class NotificationsIndex < BaseIndex
    def notifications(scope = Notification)
      @notifications ||= prepare_records(scope)
    end
  end
end