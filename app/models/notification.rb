class Notification < ApplicationRecord
  belongs_to :notifiable, polymorphic: true

  validates :message, :notifiable_id, :notifiable_type, presence: true
end
