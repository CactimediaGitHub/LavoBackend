require 'acceptance_helper'

resource "vendor/dashboard", document: :v1 do

  include_context :no_content_headers
  header 'Authorization', :token

  let(:vendor) { create(:signed_in_vendor) }
  let(:token) { "Token token=#{vendor.http_token.key}" }

  let!(:review1) { create(:review, reviewable: vendor, body: 'review 1 body') }
  let!(:review2) { create(:review, reviewable: vendor, body: 'review 2 body') }

  let!(:order) { create(:paid_order, vendor: vendor) }

  get "/vendor/dashboards" do
    context 'Successfully show vendor dashboard' do

      before do
        Review.create!(reviewable: review2, reviewer: vendor, body: 'Vendor comment body')
      end

      example_request 'Successfull order listing with pagination' do
        expect(status).to eq(200)
        expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
        # ap json(response_body)
        expect(json(response_body)[:data][:attributes][:'order-count']).to eq(1)
        expect(json(response_body)[:data][:attributes][:'review-count']).to eq(1)
      end
    end

  end
end
