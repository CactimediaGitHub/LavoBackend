class API::V1::Support::PaymentMethodCaclulator
  def self.calculate(payment)
    p = payment

    if p.order.present?
      if p.paid_amount > 0
        return Payment.payment_methods[:card]         if p.credits_amount == 0
        return Payment.payment_methods[:card_credits] if p.credits_amount > 0
      elsif p.paid_amount == 0
        return Payment.payment_methods[:credits]      if p.credits_amount == p.order_total
        return Payment.payment_methods[:cash]
      end
    else
      return Payment.payment_methods[:card]           if p.credits_amount > 0 && p.credits_amount == p.paid_amount #NOTE: bought lavo credits
      # TODO: make unknown payment method
      Payment.payment_methods[:cash]
    end
  end
end

# @payment = Payment.new do |p|
#   p.order = order
#   p.customer = customer
#   p.vendor = vendor
#   p.card = card
#   p.status = status
#   p.response_code = response_code
#   p.response_message = response_message
#   p.paid_amount = amount
#   # binding.pry
#   p.credits_amount = merchant_extra_decoded[:credits_amount]
#   p.order_total = order&.total
#   p.fort_id = fort_id
#   p.response = response
#   p.payment_method = ::API::V1::Support::PaymentMethodCaclulator.calculate(p)
# end