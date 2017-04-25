FactoryGirl.define do

  factory :schedule do
    weekday Date::DAYNAMES[1]
    vendor { create(:vendor) }
  end

end