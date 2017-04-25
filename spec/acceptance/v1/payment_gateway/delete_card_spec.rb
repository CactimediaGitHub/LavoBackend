require 'acceptance_helper'

resource "payment_gateway/cards", document: :v1 do

  include_context :no_content_headers
  header 'Authorization', :token

  let(:customer) { create(:signed_in_customer) }
  let(:token) { "Token token=#{customer.http_token.key}" }
  let(:type) { 'cards' }
  let!(:card) { create(:card, customer: customer)}
  let(:id) { card.id }

  delete '/cards/:id' do
    context 'Successfull card deletion' do
      example_request "Successfull card deletion" do
        expect(status).to eq(204)
        expect(Card.find_by(id: id)).to eq(nil)
        # expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
      end
    end

  end

end