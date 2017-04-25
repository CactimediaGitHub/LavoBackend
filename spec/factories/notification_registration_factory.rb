FactoryGirl.define do
  factory :notification_registration do
    token { TokenGenerator.uuid }
    notify true
    factory :customer_notification_registration do
      after(:build) do |t|
        t.tokenable = create(:customer)
      end
    end
    factory :vendor_notification_registration do
      after(:build) do |t|
        t.tokenable = create(:vendor)
      end
    end

  end
end