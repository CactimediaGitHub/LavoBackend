class API::V1::Review::LikesController <  API::V1::VersionController
  before_action :authenticate
  before_action :set_review, only: :destroy

  def create
    like = Like.new(like_attributes)
    if like.save
      render json: like, status: :created
    else
      render json: like,
             status: :unprocessable_entity,
             serializer: ActiveModel::Serializer::ErrorSerializer
    end
  end

  def destroy
    like = @review.likes.find_by(reviewer: current_user)
    like.destroy
  end

  private

  def set_review
    @review = Review.find(params[:review_id])
  end

  def like_params
    params.require(:data).permit(:type, :id, {
      attributes: %w(
        reviewable_type
        reviewable_id
        reviewer_type
        reviewer_id
        rating )})
  end

  def like_attributes
    like_params[:attributes] || {}
  end
end
