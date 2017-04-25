class API::V1::APIVersionTestsController < API::V1::VersionController
  def show
    render json: {content: 'v1'}, status: :ok
  end
end