class API::V1::Review::ReviewsController < API::V1::VersionController
  before_action :authenticate
  before_action :set_review, only: [:update, :destroy]

  def show
    render json: current_user.reviews.find(params[:id]),
        include: [:comments, :reviewable]
  end

  def create
    creation = API::V1::Review::CreateReview.new(review_attributes)

    if creation.performed?
      render json: creation.review,
             status: :created,
             location: [:api, creation.review],
             serializer: ReviewSerializer
    else
      render json: creation.review,
             status: :unprocessable_entity,
             serializer: ActiveModel::Serializer::ErrorSerializer
    end
  end

  def update
    if @review.update(review_attributes)
      render json: @review
    else
      render json: @review.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @review.destroy
  end

  private
    def set_review
      @review = Review.find(review_params[:id])
    end

    def review_params
      params.require(:data).permit(:type, :id, {
        attributes: %w(
          reviewable_type
          reviewable_id
          reviewer_type
          reviewer_id
          ip
          rating
          title
          body) })
    end

    def review_attributes
      review_params[:attributes] || {}
    end

end
