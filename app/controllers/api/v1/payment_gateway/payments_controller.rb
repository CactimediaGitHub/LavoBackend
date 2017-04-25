class API::V1::PaymentGateway::PaymentsController < API::V1::VersionController
  before_action :authenticate, only: [:show, :cash]

  def create
    payment = API::V1::PaymentGateway::CreatePayment.new(purchase_params).payment
    # binding.pry
    if payment.save
      #FIXME: move to payment handler or else
      if payment.success?
        payment&.order&.transition_to_pending
        if payment.credits_amount > 0
          CreditTransaction.new(customer: payment.customer,
                                  amount: payment.credits_amount,
                        transaction_type: payment.order_total ? 'paid' : 'purchased').save!
        end
      end
      head 200
    else
      Rails.logger.tagged('PAYFORT purchase callback') do
        Rails.logger.info(purchase_params.inspect)
        Rails.logger.info(payment.inspect)
      end
      head 422
    end
  end

  def show
    payment = Payment.find_by(uuid: params[:id])

    return head(404) if payment.blank?
    render json: payment,
           status: :ok
  end


  # TODO: probably time to move the following logic to service
  def cash
    order = Order.find(params[:data][:attributes][:order_id])
    payment = Payment.new do |p|
      p.order = order
      p.customer = order.customer
      p.vendor = order.vendor
      p.order_total = order.total
      p.paid_amount = 0 # NOTE: amount passed through payment gateway, thus 0,
      p.credits_amount = 0
      p.payment_method = ::API::V1::Support::PaymentMethodCaclulator.calculate(p)
    end

    if payment.save && cash_order_state_changed?(order)
      render json: {}, status: 201
    else
      head 422
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

  def completion
    completion = API::V1::PaymentGateway::PaymentCompletion.new(completion_params)
    render       json: completion,
           serializer: PaymentCompletionSerializer,
               status: 200
  end

  private

  def cash_order_state_changed?(order)
    order.openbasket? ? true : order.state_machine.transition_to!(:pending)
  end

  def completion_params
    permitted =
      %i(status response_code response_message amount merchant_reference customer_email token_name fort_id)
    params.permit(permitted)
  end

  def purchase_params
    permitted =
      %i(response status response_code response_message amount fort_id merchant_reference customer_email token_name merchant_extra)
    params.permit(permitted).merge!(response: params.to_unsafe_h)
  end
end

# "card_number"=>"455701******8902",
# "status"=>"13",
# "response_code"=>"13666",
# "response_message"=>"Transaction declined",
# "merchant_reference"=>"lBmxhStQ-132",
# "amount"=>"4500",
# "customer_email"=>"John.Doe-1@example.com",
# "token_name"=>"YY9qDg4xp",
# "fort_id"=>"1476623650161",
#
#
# "access_code"=>"B7a8a41jtuK8YBi3dSnA",
# "eci"=>"ECOMMERCE",
# "customer_name"=>"Steve Smith",
# "customer_ip"=>"92.249.109.94",
# "currency"=>"AED",
# "command"=>"PURCHASE",
# "payment_option"=>"VISA",
# "language"=>"en",
# "expiry_date"=>"175",
# "merchant_identifier"=>"lBmxhStQ",
# "signature"=>"1c05ae422abaef514f062edc91cb8fd4147fc62ca7e581607b38fba02e9acdd5"}
