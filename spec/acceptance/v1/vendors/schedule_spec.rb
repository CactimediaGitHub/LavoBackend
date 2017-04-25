require 'acceptance_helper'

resource "vendors/schedule", document: :v1 do
  include_context :no_content_headers
  header 'Authorization', :token

  parameter :vendor_id, 'Vendor id', required: true

  let(:vendor)   { create(:signed_in_vendor) }
  let(:vendor_id) { vendor.id }
  let(:token) { "Token token=#{vendor.http_token.key}" }

  let!(:monday)    { create(:schedule, weekday: Date::DAYNAMES[1], vendor: vendor) }
  let!(:tuesday)   { create(:schedule, weekday: Date::DAYNAMES[2], vendor: vendor) }
  let!(:wednesday) { create(:schedule, weekday: Date::DAYNAMES[3], vendor: vendor) }
  let!(:thursday)  { create(:schedule, weekday: Date::DAYNAMES[4], vendor: vendor) }
  let!(:friday)    { create(:schedule, weekday: Date::DAYNAMES[5], vendor: vendor) }
  let!(:saturday)  { create(:schedule, weekday: Date::DAYNAMES[6], vendor: vendor) }
  let!(:sunday)    { create(:schedule, weekday: Date::DAYNAMES[0], vendor: vendor) }

  get "/vendors/:vendor_id/schedule" do
    example_request 'Successfull rendering' do
      expect(status).to eq(200)
      expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
      expect(json(response_body)[:data].size).to eq(7)
    end
  end

end