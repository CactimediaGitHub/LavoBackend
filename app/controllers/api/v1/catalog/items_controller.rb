class API::V1::Catalog::ItemsController < API::V1::VersionController
  def index
    items = Item.all
    render json: items, status: 200
  end
end
