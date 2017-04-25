FactoryGirl.define do

  factory :shipping do
    pick_up { "[#{Time.now}, #{Time.now + 2.hours}]" }
    drop_off { "[#{Time.now + 8.hours}, #{Time.now + 8.hours + 2.hours}]" }
  end

end