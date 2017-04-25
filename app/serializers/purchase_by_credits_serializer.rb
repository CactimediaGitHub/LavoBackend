class PurchaseByCreditsSerializer < ActiveModel::Serializer
  attributes :id, :credits_amount, :order_id, :credit_transaction, :payment
  type :purchases
end
