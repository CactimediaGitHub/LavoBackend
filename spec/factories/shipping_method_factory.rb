FactoryGirl.define do

  factory :shipping_method do
    delivery_period 8

    factory :shipping_method_normal do
      shipping_charge 1000
      shipping_method_name { ShippingMethodName.create!(name: 'normal') }
    end
    factory :shipping_method_express do
      shipping_charge 1500
      shipping_method_name { ShippingMethodName.create!(name: 'express') }
    end
  end

end