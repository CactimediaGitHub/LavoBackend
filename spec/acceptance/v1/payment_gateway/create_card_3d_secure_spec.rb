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
    include SpecHelpers::VcrDoRequest[:payment_gateway_create_3d_secure_card]
    let(:customer) { create(:signed_in_customer) }
    let(:token) { "Token token=#{customer.http_token.key}" }
    let(:type) { 'cards' }

    context 'Successfull 3-D secure card creation' do
      let!(:order) { create(:order, customer: customer)}
      # let!(:order_id) { order.id }
      let(:customer) { create(:signed_in_customer) }
      let(:token) { "Token token=#{customer.http_token.key}" }
      let(:type) { 'cards' }
      let(:card) {{
        :first_name         => 'Steve',
        :last_name          => 'Smith',
        :month              => '05',
        :year               => '2017',
        :number             => '4557012345678902',
        :verification_value => '123',
        :nick               => '3-D secure card'
      }}
      let(:remember_me) { true }


      example_request 'Successfull 3-D secure card creation' do
        expect(status).to eq(200)
        ap json(response_body)
        expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
      end
    end

    context 'Validation errors' do
      let(:card) {{
        :first_name         => '',
        :last_name          => 'Smith',
        :month              => '09',
        :year               => '2017',
        :number             => '2424242424242',
        :verification_value => '',
        :nick               => ''
      }}
      let(:remember_me) { true }

      example_request 'Validation errors' do
        expect(status).to eq(422)
        ap json(response_body)

        expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
      end
    end

    context 'Validation errors when second card with existing number added' do
      let!(:existing_card) { create(:card, customer: customer) }
      let(:card) {{
        :first_name         => 'Steve',
        :last_name          => 'Smith',
        :month              => '05',
        :year               => '2017',
        :number             => '4557012345678902',
        :verification_value => '123',
        :nick               => 'My lovely card'
      }}
      let(:remember_me) { true }

      example_request 'Validation errors when second card with existing number added' do
        expect(status).to eq(422)
        ap json(response_body)
        expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
      end
    end

  end
end
