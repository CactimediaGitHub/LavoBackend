require 'acceptance_helper'

resource "customer/orders", document: :v1 do

  include_context :content_headers
  header 'Authorization', :token

  let(:customer) { create(:signed_in_customer) }
  let(:token) { "Token token=#{customer.http_token.key}" }

  let!(:order) { create(:paid_order, customer: customer) }

  get "/customer/orders" do
    context 'Successfull order listing with pagination' do
      with_options scope: %i(page) do |o|
        o.parameter :number, 'Current page number'
        o.parameter :size, 'Items per page'
      end

      let(:number) { 2 }
      let(:size) { 1 }
      let!(:order1) { create(:paid_order, customer: customer) }

      example_request 'Successfull order listing with pagination' do
        # ap json(response_body)
        expect(status).to eq(200)
        expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
        expect(json(response_body)[:data].size).to eq(1)
        expect(json(response_body)[:data][0][:id]).to eq(order.id.to_s)
      end
    end

    context 'Successfull order listing with filtering by order state' do
      with_options scope: %i(page) do |o|
        o.parameter :number, 'Current page number'
        o.parameter :size, 'Items per page'
      end

      parameter :filter, "State of the order.
                          State could be among #{OrderStateMachine.states.join(', ')}.
                          History tab on My orders screen includes done and rejected orders.
                          Additional filters for History tab: yesterday, today, week, month, quarter"

      let(:number) { 1 }
      let(:size) { 10 }
      let!(:order1) { create(:paid_order, customer: customer) }
      let!(:order2) { o = create(:paid_order, customer: customer); o.state_machine.transition_to!(:cancelled); o.reload; o }
      let!(:order3) { o = create(:paid_order, customer: customer, total: 0); o.state_machine.transition_to!(:cancelled); o.reload; o }
      let!(:order4) { o = create(:paid_order, customer: customer); o.state_machine.transition_to!(:processing); o.state_machine.transition_to!(:completed); o.reload; o }
      let(:filter) { { state: [:cancelled, :refunded, :completed], created_at: :today } }

      example_request 'Successfull order listing with filtering by order state' do
        # ap json(response_body)
        expect(status).to eq(200)
        expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
        expect(json(response_body)[:data].size).to eq(3)
        expect(json(response_body)[:meta][:"new-orders-count"]).to eq(2)
        expect(json(response_body)[:meta][:"history-orders-count"]).to eq(3)
      end
    end

  end
end
