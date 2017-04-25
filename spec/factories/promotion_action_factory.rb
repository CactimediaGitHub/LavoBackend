FactoryGirl.define do
  factory :promotion_action_create_flat_rate_adjustment, class: Promotion::Actions::CreateAdjustment do
    type { Promotion::Actions::CreateAdjustment }
    calculator_amount { 150 }
    calculator_type { build(:calculator_flat_rate).type }
  end
end

FactoryGirl.define do
  factory :promotion_action_create_flat_rate_item_adjustment, class: Promotion::Actions::CreateItemAdjustment do
    type { Promotion::Actions::CreateItemAdjustment }
    calculator_amount { 15 }
    calculator_type { build(:calculator_flat_rate).type }
  end
end

FactoryGirl.define do
  factory :promotion_action_create_flat_percent_adjustment, class: Promotion::Actions::CreateAdjustment do
    type { Promotion::Actions::CreateAdjustment }
    calculator_amount { 15 }
    calculator_type { build(:calculator_flat_percent).type }
  end
end

FactoryGirl.define do
  factory :promotion_action_create_flat_percent_item_adjustment, class: Promotion::Actions::CreateItemAdjustment do
    type { Promotion::Actions::CreateItemAdjustment }
    calculator_amount { 15 }
    calculator_type { build(:calculator_flat_percent).type }
  end
end
