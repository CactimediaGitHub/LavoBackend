class API::V1::OrderStatesController < API::V1::VersionController
  before_action :authenticate
  before_action :set_order, only: %i(show update)

  def show
    render json: @order.state_machine.allowed_transitions
  end

  def update
    if @order.state_machine.transition_to(status_params)
      render json: @order
    else
      @order.errors.add(:state, :invalid)
      render json: @order,
             status: :unprocessable_entity,
             serializer: ActiveModel::Serializer::ErrorSerializer
    end
  end

  private
    def set_order
      @order = current_user.orders.find(params[:id])
    end

    def status_params
      params.fetch(:state, 'unknown')
    end
end
