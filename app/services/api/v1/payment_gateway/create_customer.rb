class API::V1::PaymentGateway::CreateCustomer
  include ActiveModel::Model

  attr_accessor :name, :email, :description
  attr_reader :response

  def initialize(args={})
    @gateway =
      ActiveMerchant::Billing::CheckoutV2Gateway.new(secret_key: ENV['GATEWAY_CHECKOUT_KEY'])
    @card =
      ActiveMerchant::Billing::CreditCard.new(args.delete(:card))
    @description = args.fetch(:description, 'Lavo customer')

    super
    @profile = build_profile
  end

  # TODO: store remote profile id in customer
  def performed?
    create_profile
    response.success?
  end

  private

  attr_reader :gateway, :card, :profile

  def create_profile
    @response = gateway.create_customer_profile(profile)
  end

  def build_profile
    {}.tap do |h|
      h[:name] = name
      h[:email] = email
      h[:description] = description
      h[:card] = card
    end
  end
end
