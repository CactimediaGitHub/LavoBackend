class API::V1::PaymentGateway::ListCards < ActiveModelSerializers::Model

  attr_accessor :customer

  def initialize(args={})
    super
    @gateway =
      ActiveMerchant::Billing::CheckoutV2Gateway.new(secret_key: ENV['GATEWAY_CHECKOUT_KEY'])
    @profile_id = customer&.payment_gateway_profile_id
  end

  validates :profile_id, :gateway, presence: :true

  def invoke
    return [] unless valid?
    self.response = gateway.get_cards(profile_id)
  end

  private

  attr_accessor :response
  attr_reader :gateway, :profile_id
end
