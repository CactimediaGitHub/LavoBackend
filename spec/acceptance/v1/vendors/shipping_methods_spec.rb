require 'acceptance_helper'

resource "vendors/shipping_methods", document: :v1 do
  include_context :no_content_headers
  header 'Authorization', :token

  parameter :id, 'Vendor id', required: true

  let(:vendor)   { create(:signed_in_vendor) }
  let!(:shipping_normal) { create(:shipping_method_normal, vendor: vendor) }
  let!(:shipping_express) {create(:shipping_method_express, vendor: vendor) }


  let(:vendor_id) { vendor.id }
  let(:token) { "Token token=#{vendor.http_token.key}" }

  get "/vendors/:vendor_id/shipping_methods" do
    example_request 'Successfull rendering' do
      expect(status).to eq(200)
      expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
      ap json(response_body)
      expect(json(response_body)[:data].size).to eq(2)
    end
  end

end