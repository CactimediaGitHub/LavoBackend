class API::V1::CustomersController < API::V1::VersionController
  before_action :authenticate
  before_action :set_customer, only: %i(show reviews)

  def show
    render json: @customer, include: :addresses
  end

  def update
    if current_user.update(customer_attributes)
      render json: current_user
    else
      render json: current_user,
             status: :unprocessable_entity,
             serializer: ActiveModel::Serializer::ErrorSerializer
    end
  end

  def reviews
    render json: @customer.reviews, include: [:reviewable, :comments]
  end

  private

  def set_customer
    @customer = Customer.find(params[:id])
  end

  def customer_params
    params.fetch(:data, {}).permit(:type, {
      attributes: Customer.permitted_attributes
    })
  end

  def customer_attributes
    customer_params[:attributes] || {}
  end

end