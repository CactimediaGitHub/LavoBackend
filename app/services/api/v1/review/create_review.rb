class API::V1::Review::CreateReview
  include ActiveModel::Model

  attr_accessor :reviewable_type, :reviewable_id,
                :reviewer_type, :reviewer_id,
                :ip, :rating,
                :title, :body, :review,
                :reviewable, :reviewer

  def initialize(args={})
    super
    @reviewable = find_model(reviewable_type, reviewable_id)
    @reviewer = find_model(reviewer_type, reviewer_id)
    @review = Review.new(args)
  end

  delegate :errors, to: :@review

  validate :review_created?

  def performed?
    review.validate && validate
  end

  private

  def review_created?
    review.save! && reviewable.send(:update_cache!)
  rescue => e
    errors.add(:base, e.message)
  end

  def find_model(type, id)
    Object.const_get(type).find(id)
  rescue => e
    errors.add(:base, e.message)
  end

end