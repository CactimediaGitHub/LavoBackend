require 'acceptance_helper'

resource "reviews", document: :v1 do
  let(:vendor) { create(:vendor) }
  let(:customer) { create(:customer, http_token: HttpToken.new(key: TokenGenerator.uuid)) }
  let(:token) { "Token token=#{customer.http_token.key}" }

  header 'Authorization', :token
  include_context :content_headers

  parameter :type, 'reviews', scope: :data, required: true
  with_options scope: [:data, :attributes] do |o|
    o.parameter :'reviewable-type', "'Vendor' string", required: true
    o.parameter :'reviewable-id', "Vendor id", required: true
    o.parameter :'reviewer-type', "'Customer' string", required: true
    o.parameter :'reviewer-id', "Customer id", required: true
    o.parameter :rating, "Rating (1..5)", required: true
    o.parameter :title, "Review Title", required: true
    o.parameter :body, "Review Body", required: true
    o.parameter :ip, "IP address"
  end

  post "/reviews" do
    let(:'reviewable-type') { 'Vendor'}
    let(:'reviewable-id') { vendor.id }
    let(:'reviewer-type') { 'Customer' }
    let(:'reviewer-id') { customer.id }
    let(:rating) { 1.0 }
    let(:title) { 'Review title' }
    let(:body) { 'Review message' }
    let(:ip) { "127.0.0.1" }

    context 'Happy path' do
      example_request "Successfull review creation" do
        expect(status).to eq(201)
        expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
      end
    end

    context "Add another review if one exists" do
      let!(:existing_review) {
        create(:review,
          reviewable: vendor,
          reviewer: customer,
          title: 'Existing review title', body: 'Existing review body')
      }
      example_request "Successfull review creation" do
        expect(status).to eq(201)
        expect(Review.where(reviewable: vendor).count).to eq(2)
        expect(vendor.reload.cached_total_reviews).to eq(2)
        expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
      end
    end

  end

end