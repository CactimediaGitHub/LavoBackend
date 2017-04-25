require 'acceptance_helper'

resource "vendor/monthly_incomes", document: :v1 do

  include_context :no_content_headers
  header 'Authorization', :token

  let(:vendor) { create(:signed_in_vendor, commission: 3) }
  let(:token) { "Token token=#{vendor.http_token.key}" }

  let!(:order1) { create(:order, vendor: vendor) }
  let!(:order2) { create(:order, vendor: vendor) }
  let!(:order3) { create(:order, vendor: vendor) }
  let!(:payout) { create(:payout, amount: 1000, vendor: vendor) }

  before do
    Vendor.connection.execute("update orders set created_at='#{1.month.ago.to_s(:db)}' where(id = #{order1.id})")
    Vendor.connection.execute("update orders set created_at='#{2.month.ago.to_s(:db)}' where(id = #{order2.id})")
    Vendor.connection.execute("update orders set created_at='#{5.month.ago.to_s(:db)}' where(id = #{order3.id})")
    order1.state_machine.transition_to(:processing)
    order1.state_machine.transition_to(:completed)

    order2.state_machine.transition_to(:processing)
    order2.state_machine.transition_to(:completed)

    order3.state_machine.transition_to(:processing)
    order3.state_machine.transition_to(:completed)
  end

  get "/vendor/monthly_incomes" do
    context 'Show order stats by month' do
      example_request 'Show order stats by month' do
        expect(status).to eq(200)
        expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
        ap json(response_body)
        expect(vendor.balance).to eq(Calculator::OrdersNetTotal.new(vendor: vendor).compute)
        # expect(json(response_body)[:data][:attributes][:'order-count']).to eq(1)
        # expect(json(response_body)[:data][:attributes][:'review-count']).to eq(1)
      end
    end

  end
end
