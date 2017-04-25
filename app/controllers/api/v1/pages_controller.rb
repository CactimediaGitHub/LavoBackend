class API::V1::PagesController < ApplicationController
  before_action :set_page, only: :show

  def show
    render json: @page
  end

  private

  def set_page
    @page = Page.find_by(nick: params[:id])
  end
end
