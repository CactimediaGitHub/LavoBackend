require 'active_support/concern'

module UserRelated
  extend ActiveSupport::Concern

  included do
    # move to initializer
    PHONE_FORMAT_REGEXP = /\A\+?\d+\z/.freeze

    has_one  :http_token, as: :tokenable, dependent: :delete

    with_options as: :notifiable, dependent: :delete_all do |o|
      o.has_many :notifications
      o.has_many :notification_registrations, -> { where(notify: true) }
    end

    with_options class_name: 'Order' do |o|
      o.has_many :new_orders, -> { in_state(OrderStateMachine::NEW_STATES) }
      o.has_many :active_orders, -> { in_state(OrderStateMachine::ACTIVE_STATES) }
      o.has_many :history_orders, -> { in_state(OrderStateMachine::HISTORY_STATES) }
    end

    has_secure_password

    # OPTIMIZE: add image host
    mount_base64_uploader :avatar, AvatarUploader

    validates :email, email: true,
                      uniqueness: true,
                      on: %i(create update)
  end

  class_methods do
  end

end
