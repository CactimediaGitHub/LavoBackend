FactoryGirl.define do
  factory :calculator_flat_percent, class: Promotion::Calculators::FlatPercent do
    type { Promotion::Calculators::FlatPercent }
    preferred_amount 15
  end
end

FactoryGirl.define do
  factory :calculator_flat_rate, class: Promotion::Calculators::FlatRate do
    type { Promotion::Calculators::FlatRate }
    preferred_amount 100
  end
end