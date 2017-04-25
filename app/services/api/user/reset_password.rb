class API::User::ResetPassword
  include ActiveModel::Model
  include API::User::Concerns::UserUtils
  include API::Concerns::MailerUtils

  attr_accessor :user, :email, :token_generator

  def initialize(args={})
    super
    @user = self.class.find_user(email: email)
    @token_generator = args.fetch(:token_generator, ::TokenGenerator)
  end

  validates :email, email: true
  validates_presence_of :user, message: :user_presence_error, if: :email_valid?

  def performed?
    validate && update_user && send_mail(:password_digest, user)
  end

  private

  def update_user
    user.update(reset_digest: token_generator.uuid,
                reset_sent_at: Time.zone.now)
  end

  def email_valid?
    errors[:email].blank?
  end

end