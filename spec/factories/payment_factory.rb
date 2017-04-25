FactoryGirl.define do
  factory :payment do
    paid_amount 900
    credits_amount 100
    order_total 1000
    status '14'
    response_code '14000'
    response_message 'Success'
    fort_id '1234567890'
    uuid '6c0b841d4f3d4a4bbf78ec14fd70f7a1'
    response { {} }
  end
end