FactoryGirl.define do
  factory :credit_transaction do
    transaction_type CreditTransaction.transaction_types.keys.sample
  end
end