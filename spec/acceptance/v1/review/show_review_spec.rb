require 'acceptance_helper'

resource "review/show", document: :v1 do
  header 'Authorization', :token
  include_context :content_headers

  parameter :id, 'Review id', required: true

  let!(:vendor)   { create(:vendor, avatar: uploaded_file('png.png')) }
  let!(:customer) { create(:signed_in_customer, avatar: uploaded_file('png.png'))}
  let!(:review)   { vendor.review!(by: customer, title: 'Review title message', body: 'Review body message', rating: 3) }
  let!(:comment)  { Review.create!(reviewable: review, reviewer: customer, body: "Customer ##{customer.id} comment message") }
  let!(:comment1)  { Review.create!(reviewable: review, reviewer: vendor, body: "Vendor ##{vendor.id} comment message") }

  let!(:customer1) { create(:customer, avatar: uploaded_file('png.png')) }
  let!(:comment3)  { Review.create!(reviewable: review, reviewer: customer1, body: "Customer ##{customer1.id} comment message") }

  let(:token) { "Token token=#{customer.http_token.key}" }
  let(:id) { review.id }

  get '/reviews/:id' do

    example_request 'Successfull rendering' do
      expect(status).to eq(200)
      ap json(response_body)
      expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
      expect(json(response_body)[:data][:id]).to eq(review.id.to_s)
    end

  end

end