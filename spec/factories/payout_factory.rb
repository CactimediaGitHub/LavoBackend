FactoryGirl.define do
  factory :payout do
    payment_status Payout.payment_statuses.keys.sample
  end
end