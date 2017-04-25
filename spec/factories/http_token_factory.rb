FactoryGirl.define do
  factory :http_token do
    key { TokenGenerator.uuid }
    factory :customer_token do
      after(:build) do |t|
        t.tokenable = create(:customer)
      end
    end
  end
end