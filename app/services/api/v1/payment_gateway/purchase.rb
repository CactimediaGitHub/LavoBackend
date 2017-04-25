require 'active_merchant/billing/rails'

class API::V1::PaymentGateway::Purchase
  include ActiveModel::Model
  include ActiveModel::Serialization
  include Rails.application.routes.url_helpers

  attr_accessor :credits_amount, :order_id, :confirmation_url, :status, :response_code, :response_message
  attr_writer :card_token, :card_verification_value, :customer
  attr_reader :payment_uuid

  alias_attribute :id, :payment_uuid

  validates :credits_amount, numericality: { only_integer: true }
  validates :card_token, presence: true
  validates :card, presence: true

  def initialize(args={})
    super
    # TODO: move language to controller params
    @gateway =
      ActiveMerchant::Billing::PayfortGateway.new({merchant_identifier: ENV['PAYFORT_MERCHANT_ID'],
                                                           access_code: ENV['PAYFORT_ACCESS_CODE'],
                                                    sha_request_phrase: ENV['PAYFORT_REQUEST_SALT'],
                                                              language: 'en',
                                                                  test: true})
                                                                  # test: !Rails.env.production?})
    @gateway.class.logger = ActiveSupport::TaggedLogging.new(Logger.new(Rails.root.join('log/activemerchant.log')))
    @card = customer.cards.find_by(token: card_token)
    @order = Order.find_by(id: order_id)
    @token_generator = args.fetch(:token_generator, ::TokenGenerator)
    @encoder = args.fetch(:encoder, ::API::V1::Support::Encoder)
  end

  def perform
    # NOTE: we need to include CVV only on 2-nd and further purchase requests
    card.verification_value = card_verification_value if card.payments.present?
    response = gateway.purchase(purchase_amount, card, purchase_options)
    set_confirmation_url(response.params)
    set_response_fields(response.params)
  end

  def payment_uuid
    @payment_uuid ||= token_generator.uuid[0..9]
  end

  def merchant_extra_params
    # binding.pry
    encoder.urlsave_dump([credits_amount, payment_uuid])
  end

  private
  attr_reader :gateway, :card_token, :card_verification_value, :card,
              :customer, :order, :token_generator, :encoder

  # TODO: move to object
  def purchase_amount
    if order.present?
      order.total - credits_amount
    else
      credits_amount
    end
  end

  def purchase_options
    options = {}
    options[:currency] = 'AED'
    options[:customer_email] = customer.email
    options[:order_id] = order_id || token_generator.uuid[0..10]
    options[:merchant_extra] = merchant_extra_params
    options
  end

  def set_confirmation_url(args={})
    return unless args['response_code'] == '20064'
    return if args['3ds_url'].blank?
    self.confirmation_url = args['3ds_url']
  end

  def set_response_fields(args={})
    self.status = args['status']
    self.response_code = args['response_code']
    self.response_message = args['response_message']
  end
end
