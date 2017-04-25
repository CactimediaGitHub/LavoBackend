require 'active_merchant/billing/rails'

class API::V1::Support::CardUtils
  def self.mask(card)
    raise ArgumentError unless card.class == ActiveMerchant::Billing::CreditCard

    [card.class.first_digits(card.number), '*'*6, card.class.last_digits(card.number)].join
  end
end
