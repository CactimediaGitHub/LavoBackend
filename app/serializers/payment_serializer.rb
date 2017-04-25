class PaymentSerializer < ActiveModel::Serializer
  attributes :confirmation_url, :paid_amount, :credits_amount, :order_total, :status,
             :response_code, :response_message, :fort_id, :uuid, :confirmation_url, :response, :payment_method
  type :payments

  belongs_to :order
  belongs_to :vendor
  belongs_to :customer
  belongs_to :card
end
