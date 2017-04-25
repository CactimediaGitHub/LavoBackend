module Support
  class SaveNotification
    include ActiveModel::Model

    attr_accessor :message, :notify, :order

    validates :message, :notifiables, presence: true

    def perform(args={})
      if valid?
        save
      else
        Rails.logger.tagged('notification validation') do
          Rails.logger.info(self.errors.to_a.join(', '))
        end if self.errors.present?
      end
    end

    def notifiables
      @notifiables ||= notify.map { |user| order.send(user.to_sym) }
    end

    def save
      notifiables.each do |user|
        notification = Notification.create(notifiable: user, message: message, order_id: order.id)
        Rails.logger.tagged('notification save') do
          Rails.logger.info(notification.errors.to_a.join(', '))
        end if notification.errors.present?
      end
    end
  end
end
