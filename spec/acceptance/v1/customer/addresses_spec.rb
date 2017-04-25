require 'acceptance_helper'

resource "customers/addresses", document: :v1 do
  header 'Authorization', :token

  let(:customer)   { create(:signed_in_customer) }
  let(:token) { "Token token=#{customer.http_token.key}" }
  let(:type) { 'addresses' }

  post '/addresses' do
    include_context :content_headers

    parameter :type, 'addresses', scope: :data, required: true
    with_options scope: [:data, :attributes] do |o|
      o.parameter :address1, 'Customer address line 1', required: true
      o.parameter :address2, 'Customer address line 2'
      o.parameter :country, 'Customer country (iso 3 letter code)', required: true
      o.parameter :state
      o.parameter :city, 'Customer city', required: true
      o.parameter :nearest_landmark, 'Customer Nearest Landmark'
      o.parameter :human_name, 'Name of the address. Example: "My home address". FYA: not present on the screen', required: true
    end

    let!(:address1) { 'Dubai Investments Park 2' }
    let!(:city) { 'Dubai' }
    let!(:country) { 'AE' }
    let!(:nearest_landmark) { '1234567' }
    let!(:human_name) { 'My home address' }
    example_request 'Successfull address creation' do
      expect(status).to eq(201)
      expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
    end
  end

  patch '/addresses/:id' do
    include_context :content_headers

    parameter :type, 'addresses', scope: :data, required: true
    with_options scope: [:data, :attributes] do |o|
      o.parameter :address1, 'Customer address line 1', required: true
      o.parameter :address2, 'Customer address line 2'
      o.parameter :country, 'Customer country (iso 3 letter code)', required: true
      o.parameter :state
      o.parameter :city, 'Customer city', required: true
      o.parameter :nearest_landmark, 'Customer Nearest Landmark'
      o.parameter :human_name, 'Name of the address. Example: "My home address". FYA: not present on the screen', required: true
    end

    let!(:address1) { 'Dubai Investments Park 1' }
    let!(:city) { 'Dubai' }
    let!(:country) { 'AE' }
    let!(:nearest_landmark) { '1234567' }
    let!(:human_name) { 'My home address' }
    let(:address) { create :address, customer: customer }
    let(:id) { address.id }

    example_request 'Successfull address creation' do
      expect(status).to eq(200)
      expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
    end
  end

  get '/addresses' do
    include_context :no_content_headers

    let!(:address) { create(:address, customer: customer) }

    example_request 'Successfull address listing' do
      expect(status).to eq(200)
      expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
      ap json(response_body)

    end
  end

  get '/addresses/:id' do
    include_context :no_content_headers

    let(:address) { create(:address, customer: customer) }
    let(:id) { address.id }

    example_request 'Successfull address show' do
      expect(status).to eq(200)
      expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
      expect(json(response_body)[:data][:id]).to eq(address.id.to_s)
    end
  end

  delete '/addresses/:id' do
    include_context :no_content_headers

    let(:address) { create(:address, customer: customer) }
    let(:id) { address.id }

    example_request 'Successfull address destroy' do
      expect(status).to eq(204)
    end
  end

end
