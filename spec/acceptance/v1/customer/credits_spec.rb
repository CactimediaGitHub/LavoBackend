require 'acceptance_helper'

resource "customer/credits", document: :v1 do

  include_context :no_content_headers
  header 'Authorization', :token

  let(:customer) { create(:signed_in_customer) }
  let(:token) { "Token token=#{customer.http_token.key}" }

  get "/credits" do
    context 'Successfull customer credits amount listing' do
      let!(:ct1) { create(:credit_transaction, amount: 1111, transaction_type: :purchased, customer: customer) }
      let!(:ct2) { create(:credit_transaction, amount: 1110, transaction_type: :paid, customer: customer) }
      let!(:ct3) { create(:credit_transaction, amount: 2,    transaction_type: :manual_addition, note: 'For luck!', customer: customer) }
      let!(:ct4) { create(:credit_transaction, amount: 1,    transaction_type: :manual_withdrawal, customer: customer) }
      let!(:ct5) { create(:credit_transaction, amount: 1,    transaction_type: :refunded, customer: customer) }

      example_request 'Successfull customer credits amount listing' do
        expect(status).to eq(200)
        expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
        expect(json(response_body)[:data][:attributes][:'credits-amount']).to eq(3)
      end
    end
  end

end
