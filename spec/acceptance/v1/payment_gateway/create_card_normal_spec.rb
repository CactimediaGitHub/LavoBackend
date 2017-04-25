require 'acceptance_helper'

resource "payment_gateway/cards", document: :v1 do

  include_context :content_headers
  header 'Authorization', :token

  parameter :type, 'cards', scope: :data, required: true

  with_options scope: [:data, :attributes], required: true do |o|
    o.parameter :card, 'Customer credit card hash'
    o.parameter :remember_me, 'Customer allowed to tokenize and store his credit card on Payfort server'
    # o.parameter :order_id, 'Lavo order id'
  end

  with_options(scope: [:data, :attributes, :card], required: true) do |o|
    o.parameter :number, "Credit card number ('4557012345678902')"
    o.parameter :month, "Credit card expiration month ('5')"
    o.parameter :year, "Credit card expiration year ('2017')"
    o.parameter :first_name, "Cardholder first name ('Steve')"
    o.parameter :last_name, "Cardholder last name ('Smith')"
    o.parameter :verification_value, "CVV verification code ('123')"
  end

  post "/cards" do
    include SpecHelpers::VcrDoRequest[:payment_gateway_create_card_normal]
    let(:customer) { create(:signed_in_customer) }
    let(:token) { "Token token=#{customer.http_token.key}" }
    let(:type) { 'cards' }

    context 'Successfull non 3-D secure card creation' do
      let(:card) {{
        :first_name         => 'Steve',
        :last_name          => 'Smith',
        :month              => '05',
        :year               => '2017',
        :number             => '4005550000000001',
        :verification_value => '123',
        :nick               => 'Not 3-D secure card'
      }}
      let(:remember_me) { true }


      example_request 'Successfull non 3-D secure card creation' do
        expect(status).to eq(200)
        ap json(response_body)
        expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
      end
    end
  end
end
