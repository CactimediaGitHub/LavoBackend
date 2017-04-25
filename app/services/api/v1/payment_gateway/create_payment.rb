class API::V1::PaymentGateway::CreatePayment
  include ActiveModel::Model

  attr_accessor :status, :response_code, :response_message, :amount, :merchant_extra, :fort_id, :response
  attr_writer :merchant_reference, :customer_email, :token_name
  attr_reader :payment

  def initialize(args={})
    super
    @order = Order.find_by(id: merchant_reference)
    @customer = Customer.find_by(email: customer_email)
    @card = Card.find_by(customer: customer, token: token_name)
    @vendor = @order&.vendor
    @encoder = args.fetch(:encoder, ::API::V1::Support::Encoder)

    @payment = Payment.new do |p|
      p.order = order
      p.customer = customer
      p.vendor = vendor
      p.card = card
      p.status = status
      p.response_code = response_code
      p.response_message = response_message
      p.paid_amount = amount
      p.credits_amount = merchant_extra_decoded[0] || 0
      p.uuid = merchant_extra_decoded[1]
      p.order_total = order&.total
      p.fort_id = fort_id
      p.response = response
      p.payment_method = ::API::V1::Support::PaymentMethodCaclulator.calculate(p)
    end
  end

  private

  attr_reader :order, :card, :vendor, :customer
  attr_reader :merchant_reference, :customer_email, :token_name, :encoder

  def merchant_extra_decoded
    encoder.urlsave_load(merchant_extra)
  end
end


# "status"=>"13",
# "response_code"=>"13666",
# "response_message"=>"Transaction declined",
# "merchant_reference"=>"lBmxhStQ-132",
# "amount"=>"4500",
# "customer_email"=>"John.Doe-1@example.com",
# "token_name"=>"YY9qDg4xp",
# "fort_id"=>"1476623650161",