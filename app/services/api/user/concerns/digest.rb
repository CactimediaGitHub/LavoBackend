require 'active_support/concern'

module API::User::Concerns::Digest
  extend ActiveSupport::Concern

  included do
  end

  class_methods do
    def matches?(token, digest)
      return unless token
      BCrypt::Password.new(digest).is_password?(token)
    end


    def digest(token)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
      BCrypt::Password.create(token, cost: cost)
    end
  end

  extend ClassMethods

end