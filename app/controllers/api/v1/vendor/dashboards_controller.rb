class API::V1::Vendor::DashboardsController < API::V1::VersionController
  before_action :authenticate

  def index
    render json: API::V1::Vendor::ShowDashboard.new(vendor: current_user)
  end

end
