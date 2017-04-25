require 'acceptance_helper'

resource "order/openbasket approve/reject order", document: :v1 do

  include_context :content_headers
  header 'Authorization', :token

  parameter :id, 'Order id', required: true
  parameter :state, 'New order state', required: true

  let(:customer) { create(:signed_in_customer) }
  let(:token) { "Token token=#{customer.http_token.key}" }

  let(:vendor) { create(:vendor) }
  let!(:shipping_mentod) { create(:shipping_method_normal, vendor: vendor) }

  let(:order) do
    order = create(:openbasket_order, vendor: vendor, customer: customer)
    order.order_items =
      [
        build(:order_item,
               order: order,
               inventory_item: create(:inventory_item_full, vendor: vendor))
      ]
    order.shipping.update_column(:shipping_method_id, shipping_mentod.id)
    order.save!
    order.state_machine.transition_to(:pending)
    order.state_machine.transition_to(:updating)
    order.state_machine.transition_to(:approving)
    order
  end
  let(:id) { order.id }

  patch '/order_states/:id' do
    context 'Successfully approve order' do
      let(:state) { 'processing' }

      example_request 'Successfully approve order' do
        ap json(response_body)
        expect(status).to eq(200)
        expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
        expect(json(response_body)[:data][:attributes][:state]).to match('processing')
      end
    end

    context 'Successfully reject order' do
      let(:state) { 'cancelled' }

      example_request 'Successfully reject order' do
        ap json(response_body)
        expect(status).to eq(200)
        expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
        expect(json(response_body)[:data][:attributes][:state]).to match('cancelled')
      end
    end

  end
end
