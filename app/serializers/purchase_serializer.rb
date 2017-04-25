class PurchaseSerializer < ActiveModel::Serializer
  attributes :payment_uuid, :confirmation_url, :status, :response_code, :response_message
  type :purchases
end
