class API::V1::Catalog::ServicesController < API::V1::VersionController
  def index
    services = Service.all
    render json: services, status: 200
  end
end
