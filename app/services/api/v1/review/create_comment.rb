class API::V1::Review::CreateComment
  include ActiveModel::Model

  attr_accessor :reviewable_type, :reviewable_id,
                :reviewer_type, :reviewer_id,
                :body, :comment

  def initialize(args={})
    super
    @comment = Review.new(args)
  end

  validates :reviewable_id, :reviewer_id, :body, presence: true

  validates :reviewable_type, inclusion: {in: ['Review']}
  validates :reviewer_type, inclusion: {in: ['Customer', 'Vendor']}

  delegate :errors, to: :@comment

  def performed?
    validate && comment.save
  end

end