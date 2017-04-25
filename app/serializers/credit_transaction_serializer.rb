class CreditTransactionSerializer < ActiveModel::Serializer
  attributes :id, :amount, :transaction_type, :note
  has_one :customer
end
