require 'acceptance_helper'

resource "order/allowed_order_state_transitions", document: :v1 do

  include_context :no_content_headers
  header 'Authorization', :token

  parameter :id, 'Order id', required: true

  get "/order_states/:id" do
    let(:vendor) { create(:signed_in_vendor) }
    let(:token) { "Token token=#{vendor.http_token.key}" }
    let(:order) { create(:paid_order, vendor: vendor) }
    let(:id) { order.id }

    context 'Show allowed order state transitions' do
      example_request 'Show allowed order state transitions' do
        # ap json(response_body)
        expect(status).to eq(200)
        expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
        expect(json(response_body)).to match(%w(processing cancelled updating))
      end
    end
  end
end
