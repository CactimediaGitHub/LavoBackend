require 'acceptance_helper'

resource 'customer/show last completed order', document: :v1 do
  include_context :no_content_headers

  header 'Authorization', :token


  get '/customer/last_order' do

    context 'Successfull GET request' do

      let!(:customer) { create(:signed_in_customer) }
      let(:token) { "Token token=#{customer.http_token.key}" }
      let!(:order) { o = create(:paid_order, customer: customer); o.state_machine.transition_to!(:processing); o.state_machine.transition_to!(:completed); o.reload; o }

      example_request 'Successfull GET request' do
        ap json(response_body)
        expect(status).to eq(200)

        expect(json(response_body)[:data][:id]).to eq(order.id.to_s)
        expect(json(response_body)[:included][0][:id]).to eq(order.vendor.id.to_s)
      end
    end

    context 'Return null if no previous order' do
      let!(:customer) { create(:signed_in_customer) }
      let(:token) { "Token token=#{customer.http_token.key}" }

      example_request 'Return null if no previous order' do
        ap response_body
        expect(status).to eq(200)
        expect(json(response_body)[:data]).to eq(nil)
      end
    end


  end
end