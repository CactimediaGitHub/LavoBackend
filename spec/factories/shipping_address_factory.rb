FactoryGirl.define do
  factory :shipping_address do
    address1 'Dubai Investments Park 2'
    address2 '1'
    city 'Dubai'
    country 'AE'
    nearest_landmark '21345'
    # phone '+971 55 592 2783'
    human_name 'My home address'
  end
end