require 'active_merchant/billing/rails'

class API::V1::PaymentGateway::CreateCard
  include ActiveModel::Model
  include ActiveModel::Serialization
  include Rails.application.routes.url_helpers

  attr_accessor :customer, :remember_me, :return_url, :order_id, :card
  attr_reader :card
  attr_accessor :nick

  validate :card_exists?
  validate :nick_exists?

  delegate :errors, to: :card

  def initialize(args={})
    args.symbolize_keys! if args.class == Hash
    @gateway =
      ActiveMerchant::Billing::PayfortGateway.new({merchant_identifier: ENV['PAYFORT_MERCHANT_ID'],
                                                           access_code: ENV['PAYFORT_ACCESS_CODE'],
                                                    sha_request_phrase: ENV['PAYFORT_REQUEST_SALT'],
                                                              language: 'en',
                                                                  test: true})
                                                              # test: !Rails.env.production?})

    @nick = args[:card].delete(:nick)
    @card =
      ActiveMerchant::Billing::CreditCard.new(args.delete(:card))
    @token_generator = args.fetch(:token_generator, ::TokenGenerator)
    super
  end

  def store
    gateway.store(card, remember_me: remember_me,
                         return_url: return_url,
                           order_id: token_generator.uuid[0..9],
                     merchant_extra: API::V1::Support::Encoder.urlsave_dump(nick: nick))
  end

  def ready_for_job?
    valid? && card&.valid?
  end

  private
  attr_reader :gateway, :token_generator

  def card_exists?
    if Card.exists?(number: card_mask, customer: customer)
      errors.add(:number, :exists)
    end
  end

  def nick_exists?
    if Card.exists?(nick: nick, customer: customer)
      errors.add(:nick, :exists)
    end
  end

  # 455701******8902
  def card_mask
    ::API::V1::Support::CardUtils.mask(card)
  end

  def return_url_host
    [ ENV['BASE_PROTO'], ENV['BASE_API_HOST'] ].join
  end

  def return_url
    # @return_url = api_customer_cards_url(customer, host: 'https://api.lavo.devlits.com')
    url = api_customer_cards_url(customer, host: return_url_host)
    Rails.logger.tagged('card TOKENIZATION return url') { Rails.logger.info(url) }
    @return_url = url
  end
end
