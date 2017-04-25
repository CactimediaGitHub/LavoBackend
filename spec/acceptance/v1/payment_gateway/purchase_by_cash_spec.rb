require 'acceptance_helper'

resource "payment_gateway/payments/cash", document: :v1 do

  include_context :content_headers
  header 'Authorization', :auth_token

  parameter :type, 'purchases', scope: :data, required: true

  with_options scope: [:data, :attributes] do |o|
    o.parameter :order_id, 'Lavo purchased order id', required: true
  end

  let(:customer) { create(:signed_in_customer) }
  let(:auth_token) { "Token token=#{customer.http_token.key}" }
  let(:type) { 'purchases' }

  post "/payments/cash" do

    context 'Purchase by cash' do
      let!(:order) { create(:order, customer: customer)}
      let(:order_id) { order.id }

      example_request 'Purchase by cash' do
        expect(status).to eq(201)
        ap json(response_body)
        expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
        expect(Order.last.state).to eq('pending')
        expect(Payment.last.credits_amount).to eq(0)
        expect(Payment.last.paid_amount).to eq(0)
        expect(Payment.last.order_total).to eq(order.total)
        expect(Payment.last.order_id).to eq(order.id)
        expect(Payment.last.customer).to eq(customer)
        expect(Payment.last.vendor).to eq(order.vendor)
        expect(Payment.last.payment_method).to eq('cash')
      end
    end

    context 'Purchase by cash, openbasket order' do
      let!(:order) do
        order = create(:order, customer: customer, openbasket: true)
        order.state_machine.transition_to(:pending)
        order.state_machine.transition_to(:updating)
        order.state_machine.transition_to(:approving)
        order.state_machine.transition_to(:processing)
        order
      end
      let(:order_id) { order.id }

      example_request 'Purchase by cash, openbasket order' do
        expect(status).to eq(201)
        ap json(response_body)
        expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
        expect(Order.last.state).to eq('processing')
        expect(Payment.last.credits_amount).to eq(0)
        expect(Payment.last.paid_amount).to eq(0)
        expect(Payment.last.order_total).to eq(order.total)
        expect(Payment.last.order_id).to eq(order.id)
        expect(Payment.last.customer).to eq(customer)
        expect(Payment.last.vendor).to eq(order.vendor)
        expect(Payment.last.payment_method).to eq('cash')
      end
    end

  end
end
