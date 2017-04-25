require 'acceptance_helper'

resource "customers/show (private profile)", document: :v1 do
  include_context :no_content_headers

  parameter :id, 'Customer id', required: true
  header 'Authorization', :token

  let(:token) { "Token token=#{customer.http_token.key}" }
  let(:id) { customer.id }

  get "/customers/:id" do

    context 'Successfull GET request' do
      let!(:customer) { create(:signed_in_customer, avatar: uploaded_file('png.png'), addresses: [create(:address)]) }
      example_request 'Successfull GET request' do
        # ap json(response_body)
        expect(status).to eq(200)
        expect(json(response_body)[:data][:attributes][:avatar]).to be_present
        expect(File.exist?(customer.avatar.file&.path)).to be_truthy
      end
    end

    context 'Successfull GET request with default avatar' do
      let!(:customer) { create(:signed_in_customer, addresses: [create(:address)]) }
      example_request 'Successfull GET request with default avatar' do
        ap json(response_body)
        expect(status).to eq(200)
        expect(json(response_body)[:data][:attributes][:avatar]).to match("fallback/customer/default_customer_avatar")
      end
    end


  end

end