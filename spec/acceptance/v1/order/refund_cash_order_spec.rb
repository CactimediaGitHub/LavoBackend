require 'acceptance_helper'

resource "order/refunding_cash_orders", document: :v1 do

  include_context :content_headers
  header 'Authorization', :token

  parameter :id, 'Order id', required: true
  parameter :state, 'New order state', required: true

  let(:customer) { create(:signed_in_customer) }
  let!(:ct1) { create(:credit_transaction, amount: 1_000_000, transaction_type: :purchased, customer: customer) }
  let!(:initial_credits_amount) { customer.reload.credits_amount }

  let(:vendor) { create(:signed_in_vendor) }
  let!(:order) { create(:paid_order, vendor: vendor, customer: customer) }
  let!(:payment) do
    create(:payment,
           customer: customer,
             vendor: vendor,
              order: order,
        order_total: order.total,
        paid_amount: 0,
     credits_amount: 0,
     payment_method: 'cash')
   end

  let(:token) { "Token token=#{customer.http_token.key}" }
  let(:id) { order.id }
  let(:state) { 'cancelled' }

  patch "/order_states/:id" do
    context 'updates order state to "cancelled"' do
      example_request 'updates order state to "cancelled"' do
        expect(status).to eq(200)
        expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
        expect(json(response_body)[:data][:attributes][:state]).to match('refunded')
        expect(customer.reload.credits_amount).to eq(initial_credits_amount)
      end
    end
  end
end
