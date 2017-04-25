class API::V1::Catalog::ItemTypesController < API::V1::VersionController
  def index
    items = ItemType.all
    render json: items, status: 200
  end
end
