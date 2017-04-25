class API::V1::PromotionsController < API::V1::VersionController
  before_action :authenticate

  def index
    index = ::Index::PromotionsIndex.new(self)
    promotions = index.promotions(Promotion.active)
    render json: promotions, meta: pagination(promotions)
  end
end
