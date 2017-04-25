require 'acceptance_helper'

resource "vendor/search", document: :v1 do

  include_context :no_content_headers

  parameter :query, 'Search term'

  let!(:vendor1) { create(:vendor, activated: true, name: "Alfaludge laundry services", address: "Investment park 2, Dubai") }
  let!(:vendor2) { create(:vendor, activated: true, name: "Ewan laundry services", address: "Main Street, Dubai") }

  get "/vendor/search" do
    context 'Search results with pagination' do
      with_options scope: %i(page) do |o|
        o.parameter :number, 'Current page number'
        o.parameter :size, 'Items per page'
      end

      let(:number) { 1 }
      let(:size) { 1 }
      let(:query) { 'park' }

      example_request 'Search results with pagination' do
        expect(status).to eq(200)
        expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
        expect(json(response_body)[:data].size).to eq(1)
        expect(json(response_body)[:data][0][:id]).to eq(vendor1.id.to_s)
      end
    end

    context 'More search results with pagination' do
      parameter :page, 'Current page'
      let(:query) { 'Dubai' }
      let(:page) { '1' }

      before { vendor2.update_column(:activated, false)}

      example_request 'More search results with pagination' do
        expect(status).to eq(200)
        expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
        expect(json(response_body)[:data].size).to eq(1)
        expect(json(response_body)[:data][0][:id]).to eq(vendor1.id.to_s)
      end
    end


  end
end
