FactoryGirl.define do
  factory :service do
    name  { %w(Laundry Ironing Drycleaning).sample }
  end

  factory :laundry_service, class: Service do
    name  { 'Laundry' }
  end

  factory :ironing_service, class: Service do
    name  { 'Ironing' }
  end

  factory :drycleaning_service, class: Service do
    name  { 'Drycleaning' }
  end

end