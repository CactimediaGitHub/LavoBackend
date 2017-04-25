class API::V1::PaymentGateway::PurchasesController < API::V1::VersionController
  before_action :authenticate

  def create
    purchase =
      API::V1::PaymentGateway::Purchase.new(purchase_attributes)

    if purchase.valid?
      # PurchaseJob.perform_later(purchase_attributes.to_h.to_h)
      purchase.perform
      render json: purchase,
       serializer: PurchaseSerializer,
           status: 201
    else
      render json: purchase,
           status: :unprocessable_entity,
       serializer: ActiveModel::Serializer::ErrorSerializer
    end
  end

  def by_credits
    purchase =
      API::V1::PaymentGateway::PurchaseByCredits.new(purchase_by_credits_attributes)
    if purchase.valid?
      purchase.perform
      render json: purchase,
       serializer: PurchaseByCreditsSerializer,
           status: 201
    else
      render json: purchase,
           status: :unprocessable_entity,
       serializer: ActiveModel::Serializer::ErrorSerializer
    end
  end

  private

  def purchase_params
    params.fetch(:data, {}).permit(:type, {
      attributes: %i(amount card_token card_verification_value order_id customer credits_amount)
    })
  end

  def purchase_attributes
    purchase_params[:attributes].merge(customer: current_user) || {}
  end

  def purchase_by_credits_params
    params.fetch(:data, {}).permit(:type, {
      attributes: %i(order_id credits_amount)
    })
  end

  def purchase_by_credits_attributes
    purchase_params[:attributes] || {}
  end

end
