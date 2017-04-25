require 'acceptance_helper'

resource "catalog/item_typess", document: :v1 do

  include_context :no_content_headers
  header 'Authorization', :token

  let(:token) { "Token token=#{create(:customer_token).key}" }

  get "/catalog/item_types" do
    before do
      create_list(:item_type, 2)
    end

    context 'Successfull item types listing' do
      example_request 'Successfull item types listing' do
        ap json(response_body)
        expect(status).to eq(200)
        expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
        expect(json(response_body)[:data].size).to eq(2)
      end
    end

  end

end