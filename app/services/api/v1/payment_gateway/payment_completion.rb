class API::V1::PaymentGateway::PaymentCompletion
  include ActiveModel::Model
  include ActiveModel::Serialization

  attr_accessor :status, :response_code, :response_message,
                :amount, :merchant_reference, :customer_email, :token_name, :fort_id

  def lavo_message
    scope = [:activemodel, :models, :'api/v1/payment_gateway', :attributes, :lavo_message]

    case
    when status == '14' && response_code == '14000'
      I18n.t(:success, scope: scope)
    else
      I18n.t(:failure, scope: scope)
    end
  end

end
