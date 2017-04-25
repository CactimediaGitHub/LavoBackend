class API::V1::PaymentGateway::CustomersController < API::V1::VersionController

  def cards
    if params[:status] != '18'
      Rails.logger.tagged('PAYFORT card tokenization callback') do
        Rails.logger.info('Tokenization response message: ' << params[:response_message].to_s)
        Rails.logger.info('Status: ' << params[:status].to_s)
        Rails.logger.info(params.inspect)
      end and return
    end

    customer = Customer.find(params[:customer_id])

    card =
      customer.cards.build do |c|
        c.name = params[:card_holder_name]
        c.number = params[:card_number]
        c.token = params[:token_name]
        c.card_bin = params[:card_bin]
        c.expiry_date = params[:expiry_date]
        c.nick = API::V1::Support::Encoder.urlsave_load(params[:merchant_extra]).fetch(:nick, 'My credit card')
      end

    Rails.logger.info("Card is invalid: #{card.inspect}") unless card.save
    head :no_content
  end
end
