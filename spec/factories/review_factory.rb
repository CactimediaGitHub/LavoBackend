FactoryGirl.define do
  factory :review do
    rating 1
    title 'Review title'
    sequence :body do |n|
      "Review body-#{n}"
    end
    after(:build) do |r|
      r.reviewable = create(:vendor) unless r.reviewable.present?
      r.reviewer = create(:customer) unless r.reviewer.present?
    end
    after(:create) do |r|
      Review.create!(reviewable: r, reviewer: r.reviewer, body: 'Comment body')
      Review.create!(reviewable: r, reviewer: r.reviewer, rating: 1)
    end
  end
end
