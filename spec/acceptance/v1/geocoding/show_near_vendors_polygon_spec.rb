require 'acceptance_helper'

resource "geocoding/near_vendors/map", document: :v1 do

  include_context :no_content_headers

  with_options  required: true do |o|
    o.parameter :ne, "Coordinates of north east polygon corner"
    o.parameter :nw, "Coordinates of north west polygon corner"
    o.parameter :se, "Coordinates of south east polygon corner"
    o.parameter :sw, "Coordinates of south west polygon corner"
  end

  # https://www.google.com.ua/webhp?sourceid=chrome-instant&ion=1&espv=2&ie=UTF-8#safe=off&q=dubai%20laundries&rflfq=1&rlha=0&rllag=25161798,55264172,15027&tbm=lcl&tbs=lf:1,lf_ui:2&oll=25.040184027118492,55.370275644140634&ospn=0.4766502917748028,0.7664816097179568&oz=11&fll=25.168892794688283,55.469152597265634&fspn=0.4761487706283205,0.7664814349518849&fz=11&qop=1&rlfi=hd:;si:
  get "/near_vendors/map" do

    context 'Successfull lookup' do
      let!(:coord1) { Geocoder.coordinates('WH-5, Plot-597/226, Dubai Investment Park 2 - Dubai') || [] }
      let!(:coord2) { Geocoder.coordinates('Dubai Investments Park 2, Dubai') || [] }
      let!(:coord3) { Geocoder.coordinates('Dubai Investments Park 1, Dubai') || [] }
      let!(:coord4) { Geocoder.coordinates('Al Hamriya, Near Dubai Hospital, Dubai') || [] }
      let!(:coord5) { Geocoder.coordinates('10 Ibn Battuta St, Dubai') || [] }

      let!(:vendor1) { create(:activated_vendor, lat: coord1.fetch(0, 24.9745179), lon: coord1.fetch(1, 55.1983055), address: 'WH-5, Plot-597/226, Dubai Investment Park 2 - Dubai') }
      let!(:vendor2) { create(:activated_vendor, lat: coord2.fetch(0, 24.9745179), lon: coord2.fetch(1, 55.1983055), address: 'Dubai Investments Park 2, Dubai') }
      let!(:vendor3) { create(:activated_vendor, lat: coord3[0], lon: coord3[1], address: 'Dubai Investments Park 1, Dubai') }
      let!(:vendor4) { create(:activated_vendor, lat: coord4.fetch(0, 25.269735), lon: coord4.fetch(1, 55.3116909), address: 'Al Hamriya, Near Dubai Hospital, Dubai') }
      let!(:vendor5) { create(:activated_vendor, lat: coord5.fetch(0, 25.0478705), lon: coord5.fetch(1, 55.1301715), address: '10 Ibn Battuta St, Dubai') }

      let(:ne) { '24.9892695 55.2271551' }
      let(:nw) { '25.0169617 55.1595205' }
      let(:se) { '24.9578360 55.2137655' }
      let(:sw) { '24.9755767 55.1423544' }

      example_request "Successfull lookup" do
        expect(status).to eq(200)
        expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
        expect(response_body).to match('WH-5, Plot-597/226, Dubai Investment Park 2 - Dubai')
        expect(response_body).to match('Dubai Investments Park 2')
        expect(response_body).to match('Dubai Investments Park 1')
        expect(response_body).not_to match('Al Hamriya, Near Dubai Hospital')
        expect(response_body).not_to match('10 Ibn Battuta St, Dubai')
      end
    end

    context "Respond with error if parameter is missing" do
      let(:ne) { '' }

      example_request "Respond with error if parameter is missing" do
        expect(status).to eq(422)
        expect(response_body).to match("blank")
      end
    end

  end

end