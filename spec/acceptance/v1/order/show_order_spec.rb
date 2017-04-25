require 'acceptance_helper'

resource 'orders/show', document: :v1 do

  include_context :content_headers
  header 'Authorization', :token

  let(:vendor) { create(:signed_in_vendor) }
  let(:customer) { create(:signed_in_customer) }

  let!(:order) { create(:order, vendor: vendor, customer: customer) }
  let(:id) { order.id }

  get "/orders/:id" do

    context 'Vendor order view' do
      let(:token) { "Token token=#{vendor.http_token.key}" }

      example_request 'Vendor order view' do
        ap json(response_body)
        expect(status).to eq(200)
        expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
        expect(json(response_body)[:data][:attributes][:total]).to eq(4500)
        expect(json(response_body)[:data][:attributes][:openbasket]).to eq(false)
        expect(json(response_body)[:included][2][:attributes][:"shipping-charge"]).to eq(1500)
        expect(json(response_body)[:included][3][:attributes][:'human-name']).to eq('My home address')
        expect(json(response_body)[:included][4][:attributes][:quantity]).to eq(3)
        expect(json(response_body)[:included][5][:attributes][:price]).to eq(1000)
      end
    end

    context 'Customer order view' do
      let(:token) { "Token token=#{customer.http_token.key}" }

      example_request 'Customer order view' do
        ap json(response_body)
        expect(status).to eq(200)
        expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
        expect(json(response_body)[:data][:attributes][:total]).to eq(4500)
        expect(json(response_body)[:data][:attributes][:openbasket]).to eq(false)
        expect(json(response_body)[:included][2][:attributes][:"shipping-charge"]).to eq(1500)
        expect(json(response_body)[:included][3][:attributes][:'human-name']).to eq('My home address')
        expect(json(response_body)[:included][4][:attributes][:quantity]).to eq(3)
        expect(json(response_body)[:included][5][:attributes][:price]).to eq(1000)
      end
    end

  end
end
