class API::V1::User::SignUp
  include ActiveModel::Model
  include API::Concerns::MailerUtils

  # NOTE: for account update
  # attr_accessor :avatar,
  #               :email,
  #               :name,
  #               :phone,
  #               :surname,
  #               :address_attributes

  attr_accessor :email, :password, :password_confirmation


  attr_reader :customer, :token_generator, :digest_utils

  def initialize(args={})
    super
    @customer = Customer.new(args)
    @token_generator = args.fetch(:token_generator, ::TokenGenerator)
    @digest_utils = args.fetch(:digest_utils, API::User::Concerns::Digest)
  end

  # TODO: consider using external validator class
  validates :email,
            email: true,
            uniqueness: {
              model: Customer,
              attribute: :email
            }

  delegate :errors, to: :@customer

  def performed?
    create_activation_digest &&
    customer.save &&
    send_mail(:account_activation, { email: customer.email, activation_token: customer.activation_token })
  end

  private

  def create_activation_digest
    customer.activation_token = token_generator.uuid
    customer.activation_digest = digest_utils.digest(customer.activation_token)
  rescue => e
    errors.add(:base, e.message)
    false
  end
end
