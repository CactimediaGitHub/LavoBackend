class API::User::UpdatePassword
  include ActiveModel::Model
  include API::User::Concerns::UserUtils
  include API::Concerns::MailerUtils

  attr_accessor :email,
                :password,
                :password_confirmation,
                :user

  def initialize(args={})
    super
    @user = self.class.find_user(email: args.fetch(:email))
  end

  validates :email, email: true
  validates :password, presence: true, confirmation: true, length: { minimum: 6 }
  validates_presence_of :user, message: :user_presence_error, if: :email_valid?

  def performed?
    validate && update_user && send_mail(:password_updated, user)
  end

  private

  def update_user
    user.update(password: password,
                password_confirmation: password_confirmation)
  end

  def email_valid?
    errors[:email].blank?
  end

end
