class API::User::SignIn
  #FIXME: serialize this model, with email, password, user attributes
  # not need for error delegator and user serialization
  include ActiveModel::Model
  include API::User::Concerns::UserUtils

  attr_accessor :email, :password
  attr_reader :user, :resource_with_errors

  def initialize(args={})
    super
    @user = self.class.find_user(email: email)
    @resource_with_errors = ResourceWithErrors.new
  end

  validates :email, email: true
  validates :password, presence: true
  validate :user_activated?, if: :user
  validate :user_authenticated?


  delegate :errors, to: :errors_delegator

  def performed?
    validate &&
    user.create_http_token.reload
  end

  def errors_delegator
    return user if user
    resource_with_errors
  end

  private

  def user_activated?
    unless user&.activated?
      errors.add(:base, :not_activated)
    end
  end

  def user_authenticated?
    unless user&.authenticate(password)
      errors.add(:base, :bad_credentials)
    end
  end

end