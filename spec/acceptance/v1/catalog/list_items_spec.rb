require 'acceptance_helper'

resource "catalog/items", document: :v1 do

  include_context :no_content_headers
  header 'Authorization', :token

  let(:token) { "Token token=#{create(:customer_token).key}" }

  get "/catalog/items" do
    before do
      create(:item)
      create(:item, icon: uploaded_file('png.png'))
    end

    context 'Successfull items listing' do
      example_request 'Successfull items listing' do
        ap json(response_body)
        expect(status).to eq(200)
        expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
        expect(json(response_body)[:data].size).to eq(2)
        expect(json(response_body)[:data][0][:attributes][:icon][:url]).to match("fallback/item/default_icon")
      end
    end

  end

end