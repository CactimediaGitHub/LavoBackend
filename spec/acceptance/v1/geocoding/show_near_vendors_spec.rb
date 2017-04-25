require 'acceptance_helper'

resource "geocoding/near_vendors", document: :v1 do

  include_context :no_content_headers

  parameter :lat, 'Current place latitude coordinate', required: true
  parameter :lon, 'Current place longitude coordinate', required: true
  parameter :sort, "Sorting by cached_average_rating or inventory_items.price or proximity (default sort order without any sort params)"
  parameter :filter, 'Filter by inventory_items.service_id, inventory_items.item_id'

  # https://www.google.com.ua/webhp?sourceid=chrome-instant&ion=1&espv=2&ie=UTF-8#safe=off&q=dubai%20laundries&rflfq=1&rlha=0&rllag=25161798,55264172,15027&tbm=lcl&tbs=lf:1,lf_ui:2&oll=25.040184027118492,55.370275644140634&ospn=0.4766502917748028,0.7664816097179568&oz=11&fll=25.168892794688283,55.469152597265634&fspn=0.4761487706283205,0.7664814349518849&fz=11&qop=1&rlfi=hd:;si:
  get "/near_vendors" do
    let(:addr1) { 'Precinct Building 3 Dubai International Financial Center - Dubai - United Arab Emirates' }
    let(:addr2) { 'Precinct Building 2 Sheikh Zayed Rd - Dubai - United Arab Emirates' }
    let(:addr3) { 'Level 2, Building, Gate Village, Sheikh Zayed Rd، Dubai International Financial Center - Dubai - United Arab Emirates' }
    let(:addr4) { 'Dubai Investments Park 2, Dubai' }
    let!(:coord1) { Geocoder.coordinates(addr1) }
    let!(:coord2) { Geocoder.coordinates(addr2) }
    let!(:coord3) { Geocoder.coordinates(addr3) }
    let!(:coord4) { Geocoder.coordinates(addr4) }
    let!(:vendor1) { create(:activated_vendor, lat: coord1[0], lon: coord1[1], address: addr1, cached_average_rating: 5) }
    let!(:vendor2) { create(:activated_vendor, lat: coord2[0], lon: coord2[1], address: addr2, cached_average_rating: 4.3) }
    let!(:vendor3) { create(:activated_vendor, lat: coord3[0], lon: coord3[1], address: addr3, cached_average_rating: 4.5) }
    let!(:vendor4) { create(:activated_vendor, lat: coord4[0], lon: coord4[1], address: addr4, cached_average_rating: 4.1) }

    context 'Successfull lookup' do
      let(:lat) { 25.211216 }
      let(:lon) { 55.280889 }

      context 'Successfull lookup by coordinates only' do
        example_request "Successfull lookup by coordinates only" do
          expect(status).to eq(200)
          expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
          expect(response_body).to match(addr1)
          expect(response_body).to match(addr2)
          expect(response_body).to match(addr3)
          expect(response_body).not_to match(addr4)
          expect(json(response_body)[:data][0][:attributes][:lat]).to be_present
          expect(json(response_body)[:data][0][:attributes][:lon]).to be_present
        end
      end

      context 'Successfull lookup by coordinates and sorting by proximity' do

        let(:sort) {  }

        example_request 'Successfull lookup by coordinates and sorting by proximity' do
          expect(status).to eq(200)
          expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
          expect(json(response_body)[:data][0][:attributes][:lat]).to be_present
          expect(json(response_body)[:data][0][:attributes][:lon]).to be_present
        end
      end

      context 'Successfull lookup by coordinates and sorting by rating' do

        let(:sort) { '-cached-average-rating' }
        let(:customer) { create(:customer) }

        let!(:review1) { vendor1.review!(by: customer, title: 'Review title 1', body: 'Review body 1', rating: 1) }
        let!(:review2) { vendor2.review!(by: customer, title: 'Review title 2', body: 'Review body 2', rating: 3) }
        let!(:review3) { vendor3.review!(by: customer, title: 'Review title 3', body: 'Review body 3', rating: 4) }
        let!(:review4) { vendor4.review!(by: customer, title: 'Review title 4', body: 'Review body 4', rating: 5) }

        example_request 'Successfull lookup by coordinates and sorting by rating' do
          expect(status).to eq(200)
          expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
          expect(json(response_body)[:data][0][:attributes][:address]).to eq(addr3)
          expect(json(response_body)[:data][1][:attributes][:address]).to eq(addr2)
          expect(json(response_body)[:data][2][:attributes][:address]).to eq(addr1)
          expect(response_body).not_to match(addr4)
        end
      end

      context 'Successfull lookup by coordinates filter by service and item and sorting by average inventory_item price' do
        let!(:item) { create(:item) }
        let!(:item1) { create(:item) }
        let!(:service) { create(:service) }
        let!(:inventory_item1) { create(:inventory_item, price: 5000, vendor: vendor1, service: service, item: item, item_type: create(:item_type)) }
        let!(:inventory_item2) { create(:inventory_item, price: 9000, vendor: vendor1, service: service, item: item1, item_type: create(:item_type)) } # average price: 7000
        let!(:inventory_item3) { create(:inventory_item, price: 2000, vendor: vendor1, service: create(:service), item: create(:item), item_type: create(:item_type)) }

        let!(:inventory_item4) { create(:inventory_item, price: 3000, vendor: vendor2, service: service, item: item, item_type: create(:item_type)) }
        let!(:inventory_item5) { create(:inventory_item, price: 1000, vendor: vendor2, service: service, item: item1, item_type: create(:item_type)) } # average price: 2000

        let!(:inventory_item6) { create(:inventory_item, price: 4500, vendor: vendor3, service: create(:service), item: item1, item_type: create(:item_type)) }
        let!(:inventory_item7) { create(:inventory_item, price: 6500, vendor: vendor3, service: create(:service), item: create(:item), item_type: create(:item_type)) }

        let(:sort) { 'inventory_items.price' }
        let(:filter) { {'inventory-items.service-id' => service.id, 'inventory-items.item-id'=> [item.id, item1.id]} }

        example_request 'Successfull lookup by coordinates and sorting by price' do
          #NOTE: order:
          # vendor1 'Precinct Building 3 Dubai International Financial Center - Dubai - United Arab Emirates'
          # vendor2 'Precinct Building 2 Sheikh Zayed Rd - Dubai - United Arab Emirates'
          # vendor3 'Park Towers P4 Shop 2, - Dubai - United Arab Emirates'
          ap json(response_body)
          expect(status).to eq(200)
          expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
          expect(json(response_body)[:data].size).to eq(2)
          expect(json(response_body)[:data][0][:attributes][:address]).to eq(vendor2.address)
          expect(json(response_body)[:data][1][:attributes][:address]).to eq(vendor1.address)
          expect(response_body).not_to match(addr3)
          expect(response_body).not_to match(addr4)
        end
      end

    end

    # context "Respond with error if parameter is missing" do
    #   let(:lat) { '' }
    #
    #   example_request "Respond with error if parameter is missing" do
    #     expect(status).to eq(422)
    #     expect(response_body).to match("blank")
    #   end
    # end

  end

end
