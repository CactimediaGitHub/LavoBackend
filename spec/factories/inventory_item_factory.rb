FactoryGirl.define do
  factory :inventory_item do
    price 1000
    factory :inventory_item_full do
      after(:build) do |r|
        r.vendor = create(:signed_in_vendor) unless r.vendor.present?
        r.item = create(:item)
        r.item_type = create(:item_type)
        r.service = create(:service)
      end
    end
  end
end