require 'acceptance_helper'

resource "payment_gateway/cards", document: :v1 do

  include_context :no_content_headers
  header 'Authorization', :token

  let(:customer) { create(:signed_in_customer) }
  let(:token) { "Token token=#{customer.http_token.key}" }

  get '/cards/:id' do
    context 'Successfull card showing first purchase' do
      let!(:card) { create(:card, customer: customer) }
      let(:id) { card.number }

      example_request 'Successfull card showing first purchase' do
        expect(status).to eq(200)
        ap json(response_body)
        expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
        expect(json(response_body)[:data][:attributes][:token]).to eq(card.token)
        expect(json(response_body)[:data][:attributes][:'first-purchase']).to eq(true)
      end
    end

    context 'Successfull card showing second and succeeded purchases' do
      let!(:card) { create(:card, customer: customer) }
      let(:id) { card.number }
      let!(:order) { create(:order) }

      let!(:payment) { create(:payment, customer: customer, vendor: order.vendor, order: order, card: card) }

      example_request 'Successfull card showing second and succeeded purchases' do
        expect(status).to eq(200)
        ap json(response_body)
        expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
        expect(json(response_body)[:data][:attributes][:token]).to eq(card.token)
        expect(json(response_body)[:data][:attributes][:'first-purchase']).to eq(false)
      end
    end

    context '404 if no card present' do
      let(:id) { '455701******8902' }

      example_request '404 if no card present' do
        expect(status).to eq(404)
      end
    end
  end
end
