class API::User::GenerateTmpPassword
  include ActiveModel::Model
  include API::User::Concerns::UserUtils
  include API::Concerns::MailerUtils

  attr_accessor :user, :token_generator, :reset_digest

  def initialize(args={})
    super
    @user = self.class.find_user(reset_digest: reset_digest)
    @token_generator = args.fetch(:token_generator, ::TokenGenerator)
  end

  validates_presence_of :user, message: :user_presence_error
  validate :reset_digest_expiration

  def performed?
    validate && generate_pass && send_mail(:password_generated, user, @pwd)
  end

  private

  def generate_pass
    user.password = @pwd = user.password_confirmation = token_generator.password
    user.save
  end

  def reset_digest_expiration
    return unless user
    if user.reset_sent_at < 3.hours.ago
      errors.add(:reset_digest, :expired)
    end
    #TODO: send pass expiration email
  end

end