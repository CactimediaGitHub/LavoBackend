FactoryGirl.define do
  factory :card do
    name { 'Steve Smith' }
    number { '455701******8902' }
    token { '3F36728453274738E053321E320A846C' }
    card_bin { '455701' }
    expiry_date { '175' }
    nick { 'My lovely card' }
  end
end