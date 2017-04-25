require 'acceptance_helper'

resource 'payment_gateway/payments/completion', document: :v1 do

  include_context :no_content_headers
  #
  parameter :access_code
  parameter :eci
  parameter :card_number
  parameter :status
  parameter :fort_id
  parameter :response_code
  parameter :token_name
  parameter :customer_name
  parameter :customer_email
  parameter :customer_ip
  parameter :currency
  parameter :merchant_reference
  parameter :amount
  parameter :response_message
  parameter :command
  parameter :payment_option
  parameter :language
  parameter :authorization_code
  parameter :expiry_date
  parameter :merchant_identifier
  parameter :merchant_extra
  parameter :signature

  let!(:customer) { create(:customer)}
  let!(:order) { create(:paid_order, customer: customer)}
  let!(:card) { order.payment.card }

  let(:access_code)        {  "B7a8a41jtuK8YBi3dSnA" }
  let(:eci)                { "ECOMMERCE" }
  let(:card_number)        { "455701******8902" }
  let(:fort_id)            { "1476622416229" }
  let(:token_name)         { card.token }
  let(:customer_name)      { "Steve Smith" }
  let(:customer_email)     { customer.email }
  let(:customer_ip)        { "123.123.123.123" }
  let(:currency)           { "AED" }
  let(:command)            { "PURCHASE" }
  let(:payment_option)     { "VISA" }
  let(:language)           { "en" }
  let(:authorization_code) { "466193" }
  let(:expiry_date)        { "175" }
  let(:merchant_identifier){ "lBmxhStQ" }
  let(:signature)          {  "083e40f7cc056ca753886cdd5e5865653a382545bf7d567de3097a218515e8f4" }
  let(:merchant_reference) { order.id.to_s }
  let(:amount)             { "4500" }

  get '/payments/completion' do

    context 'Successfull payment' do
      let!(:raw_post) { params.merge!(status: "14").to_json }
      let(:response_message)   { "Success" }
      let(:response_code)      { "14000" }
      let(:status)             { "14" }

      example_request 'Successfull payment' do
        # expect(status).to eq(200)
        ap json(response_body)
        expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
      end
    end

  end
end
