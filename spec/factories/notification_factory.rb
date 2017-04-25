FactoryGirl.define do
  factory :notification do
    sequence :message do |n|
      "Test message #{n}: your order has been approved."
    end
  end
end