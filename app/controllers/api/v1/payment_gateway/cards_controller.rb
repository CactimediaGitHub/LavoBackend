class API::V1::PaymentGateway::CardsController < API::V1::VersionController
  before_action :authenticate

  def index
    render json: current_user.cards,
           status: :ok,
           include: :customer
  end

  def create
    creation =
      API::V1::PaymentGateway::CreateCard.new(card_attributes)
    if creation.ready_for_job?
      TokenizeCardJob.perform_later(card_attributes.to_h.to_h)
      render json: creation.card,
           status: 200,
       serializer: CreditCardSerializer
    else
      render json: creation.card,
           status: :unprocessable_entity,
       serializer: ActiveModel::Serializer::ErrorSerializer
    end
  end

  def destroy
    card = current_user.cards.find(params[:id])
    card.destroy
    head :no_content
  end

  def show
    cards = current_user.cards

    return head(404) unless cards.exists?(number: params[:id])

    card = cards.find_by(number: params[:id])
    render json: card,
           status: :ok
  end

  private

  def card_params
    params.fetch(:data, {}).permit(:type, :id, {
      attributes: [:remember_me, :order_id,
        card: %w(
          number
          month
          year
          first_name
          last_name
          verification_value
          nick
        )]
    })
  end

  def card_attributes
    card_params[:attributes].merge(customer: current_user) || {}
    # card_params[:attributes].
      # merge(customer: current_user).
      # merge(return_url: api_payment_gateway_customer_cards_url(current_user, host: 'https://api.lavo.devlits.com')) || {}
  end

end