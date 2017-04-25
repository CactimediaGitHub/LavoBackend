require 'acceptance_helper'

resource "payment_gateway/purchases", document: :v1 do

  include_context :content_headers
  header 'Authorization', :auth_token

  parameter :type, 'purchases', scope: :data, required: true

  with_options scope: [:data, :attributes] do |o|
    o.parameter :card_token, 'Payfort credit card token. E.g.: Op9Vmp', required: true
    o.parameter :card_verification_value, 'Serialized card verification value (CVV, e.g. 123)', required: true
    o.parameter :order_id, 'Lavo purchased order id', required: true
    o.parameter :credits_amount, 'Lavo credits value in cents. E.g. 10000.', required: true
  end

  let(:customer) { create(:signed_in_customer) }
  let!(:card) { c = create(:card, customer: customer, token: '413E6A6622A34858E053321E320ACEF7'); customer.cards << c; c }
  let(:auth_token) { "Token token=#{customer.http_token.key}" }
  let(:type) { 'purchases' }
  let(:order) { create(:order, customer: customer)}

  before do
    Order.connection.execute("select setval('orders_id_seq', extract(epoch from now())::integer)")
  end

  post "/purchases" do
    # NOTE: vcr cassete was recorded on the first card payment
    include SpecHelpers::VcrDoRequest[:payment_gateway_purchases_normal_card_first_payment]

    context 'Successfull purchase without credits using normal card' do
      let(:order_id) { order.id }
      let(:credits_amount) { 0 }
      let(:card_token) { card.token }
      let(:card_verification_value) { 123 }

      example_request 'Successfull purchase without credits using normal card' do
        expect(status).to eq(201)
        ap json(response_body)
        expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
      end
    end
  end
end
