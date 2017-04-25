require 'acceptance_helper'

resource 'payment_gateway/payments', document: :v1 do

  include_context :content_headers
  #
  parameter :access_code
  parameter :eci
  parameter :card_number
  # parameter :status
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
  let!(:order) { create(:order, customer: customer)}
  let!(:card) { create(:card, customer: customer)}

  let(:access_code)        {  "B7a8a41jtuK8YBi3dSnA" }
  let(:eci)                { "ECOMMERCE" }
  let(:card_number)        { "455701******8902" }
  # let(:status)             { "14" }
  let(:fort_id)            { "1476622416229" }
  let(:response_code)      { "13666" }
  let(:token_name)         { card.token }
  let(:customer_name)      { "Steve Smith" }
  let(:customer_email)     { customer.email }
  let(:customer_ip)        { "123.123.123.123" }
  let(:currency)           { "AED" }
  let(:response_message)   { "Success" }
  let(:command)            { "PURCHASE" }
  let(:payment_option)     { "VISA" }
  let(:language)           { "en" }
  let(:authorization_code) { "466193" }
  let(:expiry_date)        { "175" }
  let(:merchant_identifier){ "lBmxhStQ" }
  let(:signature)          {  "083e40f7cc056ca753886cdd5e5865653a382545bf7d567de3097a218515e8f4" }

  #TODO: add verification for user credits and other
  post '/payments' do
    let(:raw_post) { params.merge(status: "14").to_json }

    context 'Successfull payment creation without credits' do
      let(:merchant_reference) { order.id.to_s }
      let(:amount)             { "4500" }
      let(:merchant_extra) { 'BAhbB2kASSIPZGE5MDZiNGY2ZAY6BkVG' }
      example_request 'Successfull payment creation without credits' do
        expect(status).to eq(200)
        expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}")
      end
    end

    context 'Successfull payment creation with credits' do
      let(:merchant_reference) { order.id.to_s }
      let(:amount)             { "4400" }
      let(:merchant_extra) { 'BAhbB2lpSSIPYjYyMDE3NDc2YgY6BkVG' }
       # 100
      let!(:ct1) { create(:credit_transaction, amount: 101, transaction_type: :purchased, customer: customer) }
      example_request 'Successfull payment creation with credits' do
        expect(status).to eq(200)
        expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}")
        expect(Payment.last.uuid).to be_present
        expect(Payment.last.credits_amount).to eq(100)
        expect(customer.reload.credits_amount).to eq(1)
      end
    end

    context 'Successfull payment creation, credits only' do
      let(:merchant_reference) { 'uuid-value' }
      let(:amount)             { "100" }
      let(:merchant_extra) { 'BAhbB2lpSSIPYjYyMDE3NDc2YgY6BkVG' }
       # 100
      let!(:ct1) { create(:credit_transaction, amount: 101, transaction_type: :purchased, customer: customer) }
      example_request 'Successfull payment creation, credits only' do
        expect(status).to eq(200)
        expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}")
        expect(Payment.last.uuid).to be_present
        expect(Payment.last.credits_amount).to eq(100)
        expect(customer.reload.credits_amount).to eq(201)
      end
    end

    context 'Successfull payment creation lavo credits purchase' do
      let(:merchant_reference) { 'uuid-value' }
      let(:amount)             { "100" }
      let(:merchant_extra) { 'BAhbB2lpSSIPYjYyMDE3NDc2YgY6BkVG' }
       # 100
      example_request 'Successfull payment creation lavo credits purchase' do
        expect(status).to eq(200)
        expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}")
        expect(Payment.last.payment_method).to eq('card')
      end
    end

  end
end
