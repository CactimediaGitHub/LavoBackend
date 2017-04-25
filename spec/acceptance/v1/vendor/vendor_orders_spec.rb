require 'acceptance_helper'

resource "vendor/orders", document: :v1 do

  include_context :content_headers
  header 'Authorization', :token

  let(:vendor) { create(:signed_in_vendor) }
  let(:token) { "Token token=#{vendor.http_token.key}" }

  let!(:order) { create(:paid_order, vendor: vendor) }

  get "/vendor/orders" do
    context 'Successfull order listing with pagination' do
      with_options scope: %i(page) do |o|
        o.parameter :number, 'Current page number'
        o.parameter :size, 'Items per page'
      end

      let(:number) { 2 }
      let(:size) { 1 }
      let!(:order1) { create(:paid_order, vendor: vendor) }

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

      let(:number) { 2 }
      let(:size) { 1 }
      let(:filter) { { state: [:pending, :refunded], created_at: :today } }
      let!(:order1) { create(:paid_order, vendor: vendor) }
      let!(:order2) { o = create(:paid_order, vendor: vendor); o.state_machine.transition_to!(:cancelled); o }

      example_request 'Successfull order listing with filtering by order state' do
        # ap json(response_body)
        expect(status).to eq(200)
        expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
        expect(json(response_body)[:data].size).to eq(1)
        expect(json(response_body)[:data][0][:id]).to eq(order1.id.to_s)
      end
    end

  end
end
