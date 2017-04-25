class NotificationRegistration < ApplicationRecord
  belongs_to :notifiable, polymorphic: true

  validates :notify,
            :notifiable_id,
            :notifiable_type,
            :token,
            presence: true
  validates :token, uniqueness: true
end
