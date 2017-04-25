require 'acceptance_helper'

resource "vendors/inventory_items", document: :v1 do
  include_context :no_content_headers
  header 'Authorization', :token

  parameter :id, 'Vendor id', required: true

  let!(:vendor)   { create(:signed_in_vendor) }
  let(:laundry_service) { create(:laundry_service) }
  let(:ironing_service) { create(:ironing_service) }
  let(:drycleaning_service) { create(:drycleaning_service) }

  let!(:inventory_item1)  { create(:inventory_item, service: laundry_service, vendor: vendor, item: create(:item), item_type: create(:item_type)) }
  let!(:inventory_item2)  { create(:inventory_item, service: laundry_service, vendor: vendor, item: create(:item), item_type: create(:item_type)) }
  let!(:inventory_item3)  { create(:inventory_item, service: ironing_service, vendor: vendor, item: create(:item), item_type: create(:item_type)) }
  let!(:inventory_item4)  { create(:inventory_item, service: drycleaning_service, vendor: vendor, item: create(:item), item_type: create(:item_type)) }


  let(:vendor_id) { vendor.id }
  let(:token) { "Token token=#{vendor.http_token.key}" }

  context 'Successfull rendering with services and items' do
    get "/vendors/:vendor_id/inventory_items" do
      example_request 'Successfull rendering with services and items' do
        expect(status).to eq(200)
        ap json(response_body)
        expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
      end
    end
  end

  context 'Successfull rendering items only' do
    get '/vendors/:vendor_id/inventory_items/items' do
      example_request 'Successfull rendering items only' do
        expect(status).to eq(200)
        ap json(response_body)
        expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
      end
    end
  end

  context 'Successfull rendering services only' do
    get '/vendors/:vendor_id/inventory_items/services' do
      example_request 'Successfull rendering services only' do
        expect(status).to eq(200)
        ap json(response_body)

        expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
      end
    end
  end

  context 'Successfull rendering item_types only' do
    get '/vendors/:vendor_id/inventory_items/item_types' do
      example_request 'Successfull rendering item_types only' do
        expect(status).to eq(200)
        ap json(response_body)

        expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
      end
    end
  end

end