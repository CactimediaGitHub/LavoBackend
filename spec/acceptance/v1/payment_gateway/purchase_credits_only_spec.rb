require 'acceptance_helper'

resource "payment_gateway/purchases", document: :v1 do

  include_context :content_headers
  header 'Authorization', :auth_token

  parameter :type, 'purchases', scope: :data, required: true

  with_options scope: [:data, :attributes] do |o|
    o.parameter :card_token, 'Payfort credit card token. E.g.: Op9Vmp', required: true
    o.parameter :card_verification_value, 'Card CVV', required: true
    o.parameter :credits_amount, 'Lavo credits value in cents. E.g. 10000', required: true
  end

  response_field :'3ds_url', 'The URL where the Merchant redirects a customer whose card is 3-D Secure for authentication. (https://en.wikipedia.org/wiki/3-D_Secure)'

  let(:customer) { create(:signed_in_customer) }
  let!(:card) { c = create(:card, customer: customer); customer.cards << c; c }
  let(:auth_token) { "Token token=#{customer.http_token.key}" }
  let(:type) { 'purchases' }

  post "/purchases" do
    include SpecHelpers::VcrDoRequest[:payment_gateway_purchases_credits_only]


    context 'Successfull purchase credits only' do
      let(:credits_amount) { 10 }
      let(:card_token) { card.token }
      let(:card_verification_value) { 123 }

      example_request 'Successfull purchase credits only' do
        expect(status).to eq(201)
        ap json(response_body)
        expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
      end
    end
  end
end
