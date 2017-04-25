class API::V1::User::SignupsController < API::V1::VersionController

  def create
    creation = API::V1::User::SignUp.new(customer_attributes)

    if creation.performed?
      render json: creation.customer,
          include:[:address, :http_token],
       serializer: CustomerSerializer,
           status: :created,
         location: [:api, creation.customer]
    else
      render json: creation.customer,
       serializer: ActiveModel::Serializer::ErrorSerializer,
           status: :unprocessable_entity
    end
  end

  private

  def customer_params
    params.require(:data).permit(:type, :id, {
      attributes: ::Customer.permitted_attributes
      })
  end

  def customer_attributes
    customer_params[:attributes] || {}
  end

end