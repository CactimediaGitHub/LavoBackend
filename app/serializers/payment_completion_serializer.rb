class PaymentCompletionSerializer < ActiveModel::Serializer
  attributes :lavo_message, :status, :response_code, :response_message,
             :amount, :merchant_reference, :customer_email, :token_name, :fort_id

  type :payments

  def id
    object.fort_id
  end
end