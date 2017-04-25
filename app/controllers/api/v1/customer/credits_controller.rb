class API::V1::Customer::CreditsController < API::V1::VersionController

  before_action :authenticate

  def index
    render json: current_user, fields: { customers: [:credits_amount] }
  end
end
