class API::V2::APIVersionTestsController < ApplicationController
  def show
    render json: {content: 'v2'}, status: :ok
  end
end