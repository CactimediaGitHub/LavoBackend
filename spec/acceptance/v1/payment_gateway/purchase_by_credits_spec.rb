require 'acceptance_helper'

resource "payment_gateway/purchases/by_credits", document: :v1 do

  include_context :content_headers
  header 'Authorization', :auth_token

  parameter :type, 'purchases', scope: :data, required: true

  with_options scope: [:data, :attributes] do |o|
    o.parameter :order_id, 'Lavo purchased order id', required: true
    o.parameter :credits_amount, 'Lavo credits value in cents. E.g. 10000', required: true
  end

  let(:customer) { create(:signed_in_customer) }
  let(:auth_token) { "Token token=#{customer.http_token.key}" }
  let(:type) { 'purchases' }
  let!(:order) { create(:order, customer: customer)}

  post "/purchases/by_credits" do
    context 'Successfull purchase by credits for the whole order total' do
      let(:order_id) { order.id }
      let(:credits_amount) { order.total }
      let!(:ct1) { create(:credit_transaction, amount: (order.total + 1), transaction_type: :purchased, customer: customer) }

      example_request 'Successfull purchase by credits for the whole order total' do
        expect(status).to eq(201)
        ap json(response_body)
        expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
        expect(customer.reload.credits_amount).to eq(1)
        expect(Payment.last.credits_amount).to eq(credits_amount)
        expect(Payment.last.paid_amount).to eq(0)
        expect(Payment.last.order_total).to eq(credits_amount)
        expect(Payment.last.order_id).to eq(order_id)
        expect(Payment.last.customer).to eq(customer)
        expect(Payment.last.vendor).to eq(order.vendor)
        expect(Payment.last.payment_method).to eq('credits')
        expect(order.reload.state).to eq('pending')
      end
    end

    context 'Validation errors: insufficient credits' do
      let(:order_id) { order.id }
      let(:credits_amount) { order.total }
      let!(:ct1) { create(:credit_transaction, amount: (order.total - 1), transaction_type: :purchased, customer: customer) }

      example_request 'Validation errors: insufficient credits' do
        expect(status).to eq(422)
        ap json(response_body)
        expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
        expect(customer.reload.credits_amount).to eq(order.total - 1)
      end
    end

  end
end
