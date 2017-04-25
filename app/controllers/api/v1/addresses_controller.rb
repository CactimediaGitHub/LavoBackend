class API::V1::AddressesController < API::V1::VersionController

  before_action :authenticate
  before_action :set_address, only: %i[show update destroy]

  def index
    render json: current_user.addresses
  end

  def create
    @address = current_user.addresses.build(address_attributes)

    if @address.save
      render json: @address,
             status: :created
    else
      render json: @address,
             serializer: ActiveModel::Serializer::ErrorSerializer,
             status: :unprocessable_entity
    end
  end

  def update
    if @address.update(address_attributes)
      render json: @address
    else
      render json: @address,
             serializer: ActiveModel::Serializer::ErrorSerializer,
             status: :unprocessable_entity
    end
  end

  def show
    render json: @address
  end

  def destroy
    @address.destroy
  end

  private
    def set_address
      @address = current_user.addresses.find(params[:id])
    end

    def address_params
      params.fetch(:data, {}).permit(:type, {
        attributes: Address.permitted_attributes
      })
    end

    def address_attributes
      address_params[:attributes] || {}
    end
end
