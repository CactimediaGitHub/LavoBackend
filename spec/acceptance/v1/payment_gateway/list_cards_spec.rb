require 'acceptance_helper'

resource "payment_gateway/cards", document: :v1 do

  include_context :no_content_headers
  header 'Authorization', :token

  let(:customer) { create(:signed_in_customer) }
  let(:token) { "Token token=#{customer.http_token.key}" }
  let!(:card) { create(:card, customer: customer) }

  get "/cards" do
    context 'Successfull card listing' do
      example_request "Successfull card listing" do
        expect(status).to eq(200)
        ap json(response_body)
        expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
      end
    end

  end

end