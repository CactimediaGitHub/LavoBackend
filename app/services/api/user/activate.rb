class API::User::Activate
  include ActiveModel::Model
  include API::User::Concerns::UserUtils
  include API::User::Concerns::Digest

  attr_accessor :email, :token, :user, :token_generator

  def initialize(args={})
    super
    @user = self.class.find_user(email: email)
    @token_generator = args.fetch(:token_generator, ::TokenGenerator)
  end

  validates :email, email: true
  validates :token, presence: true
  validates_presence_of :user, message: :user_presence_error, if: :email_valid?
  validate :user_inactive, :token_matches_digest?

  def performed?
    valid? && activated?
  end

  private

  def activated?
    http_token = HttpToken.new(key: token_generator.uuid)
    user.update(activated: true, http_token: http_token)
    # TODO: send activation email
  end

  def token_matches_digest?
    unless self.class.matches?(token, user.activation_digest)
      errors.add(:token, :invalid)
    end
  end

  def email_valid?
    errors[:email].blank?
  end

  def user_inactive
    if user.activated?
      errors.add(:user, :already_activated)
    end
  end

end