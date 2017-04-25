require 'acceptance_helper'

resource "payment_gateway/payfort card callback", document: :v1 do

  include_context :no_content_headers

  parameter :customer_id, 'Card holder id in our db', required: true
  parameter :card_number, 'Masked card number, e.g. 424242******4242', required: true
  parameter :card_bin, 'The first 6 digits of a credit card number are known as as Bank Identification Number (BIN)', required: true
  parameter :card_holder_name, 'Card holder name. i.g. Steve Smith', required: true
  parameter :expiry_date, 'Card expiry date. Frist two digits represents year. 179', required: true
  parameter :status, 'Payfort status. 18 - Tokenization success. https://testfort.payfort.com/api/?shell#statuses', required: true
  parameter :token_name, 'Credit card token for authorization/purchase request'
  parameter :remember_me, 'This parameter provides you with an indication to whether to save this token for the user based on the user selection.', required: true
  parameter :response_message, 'Message description of the response code.', required: true
  parameter :merchant_extra, 'base64 marshalled object, currently - human nickname of the card (hash)'

  let(:customer) { create(:customer) }
  let(:customer_id) { customer.id }

  let(:card_number) { '424242******4242' }
  let(:card_bin) { '424242' }
  let(:card_holder_name) { 'Steve Smith' }
  let(:expiry_date) { '179' }
  let(:merchant_extra) { 'BAh7BjoJbmlja0kiE015IGxvdmVseSBjYXJkBjoGRVQ' }

  get '/customers/:customer_id/cards' do
    context 'Successfull callback' do
      let(:status) { '18' }
      let(:token_name) { '3GxEalGB6' }
      let(:remember_me) { 'YES' }
      let(:response_message) { 'Success' }

      example_request 'Successfull callback' do
        expect(response_status).to eq(204)
        expect(customer.cards.size).to eq(1)
        expect(customer.cards.first.nick).to eq('My lovely card')
      end
    end

    context 'Tokenization failed' do
      let(:status) { '17' }
      let(:remember_me) { 'YES' }
      let(:response_message) { 'Tokenization failed.' }

      example_request 'Tokenization failed' do
        expect(response_status).to eq(204)
        expect(customer.cards.size).to eq(0)
      end
    end

    context 'Customer dont want to save the card' do
      let(:status) { '18' }
      let(:remember_me) { 'NO' }
      let(:response_message) { 'Success' }

      example_request 'Customer dont want to save the card' do
        expect(response_status).to eq(204)
        expect(customer.cards.size).to eq(0)
      end
    end

  end

end

# access_code=B7a8a41jtuK8YBi3dSnA
# card_number=424242******4242
# status=18
# response_code=18000
# token_name=3GxEalGB6
# card_bin=424242
# service_command=TOKENIZATION
# return_url=https%3A%2F%2Fexample.com
# merchant_reference=lBmxhStQ
# card_holder_name=Steve+Smith
# remember_me=YES
# response_message=Success
# language=en
# expiry_date=179
# merchant_identifier=lBmxhStQ
# signature=f13298a94f1b3b4f1f21257eb0beba55fcc95c5ec68e45bed701a3b57ebb74dd'