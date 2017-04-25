class API::V1::Customer::LastOrdersController < API::V1::VersionController

  before_action :authenticate

  def show
    order =
      current_user.orders.in_state(:completed).
      order(created_at: :desc).limit(1).first

    render json: (order || {data:nil}.to_json),
           include: :vendor
  end
end
