class API::V1::Review::CommentsController <  API::V1::VersionController

  before_action :authenticate
  before_action :set_comment, only: %i(update destroy)

  def create
    creation = API::V1::Review::CreateComment.new(comment_attributes)

    if creation.performed?
      render json: creation.comment,
             status: :created,
             serializer: CommentSerializer
    else
      render json: creation.comment,
             status: :unprocessable_entity,
             serializer: ActiveModel::Serializer::ErrorSerializer
    end
  end

  def update
    if @comment.update(comment_attributes.slice(:body))
      render json: @comment,
             status: 200,
             serializer: CommentSerializer
    else
      render json: @comment,
             status: :unprocessable_entity,
             serializer: CommentSerializer
    end
  end

  def destroy
    @comment.destroy
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.fetch(:data, {}).permit(:type, :id, {
      attributes: %w(
        reviewable_type
        reviewable_id
        reviewer_type
        reviewer_id
        body )})
  end

  def comment_attributes
    comment_params[:attributes] || {}
  end
end
