require 'acceptance_helper'

resource "vendors/show (public, private profile)", document: :v1 do
  include_context :no_content_headers

  parameter :id, 'Vendor id', required: true
  parameter :customer_id, 'Optional customer id'

  let!(:customer) { create(:customer) }
  let!(:review)   { vendor.review!(by: customer, title: 'Title blah', body: 'Body blah', rating: 3) }
  let!(:comment)  { Review.create!(reviewable: review, reviewer: customer, body: 'Comment body') }
  let!(:like)     { Review.create!(reviewable: review, reviewer: customer, rating: 1) }
  let!(:order)    { create(:paid_order, customer: customer, vendor: vendor) }

  let(:id) { vendor.id }
  let(:type) { 'vendors' }
  let(:customer_id) { customer.id }

  get "/vendors/:id" do

    before do
      # order.state_machine.transition_to(:pending)
      order.state_machine.transition_to(:processing)
      order.reload.state_machine.transition_to(:completed)
    end

    context 'Successfull GET request with image gallery' do
      let!(:vendor)   { create(:vendor, avatar: uploaded_file('png.png'), images: [uploaded_file('png.png')]) }

      example_request "Successfull GET request with image gallery" do
        ap json(response_body)
        expect(status).to eq(200)
        expect(json(response_body)[:data][:attributes][:images][0][:url]).to be_present
        expect(json(response_body)[:data][:attributes][:'cached-total-reviews']).to eq(1)
        expect(json(response_body)[:data][:attributes][:'cached-average-rating']).to eq(3)
        expect(json(response_body)[:included][0][:attributes][:'comments-count']).to eq(1)
        expect(json(response_body)[:included][0][:attributes][:'likes-count']).to eq(1)
        expect(json(response_body)[:meta][:'order-count']).to eq(1)
        expect(json(response_body)[:meta][:'can-review']).to eq(false)
        expect(File.exist?(vendor.images.first.file.path)).to be_truthy
        expect(File.exist?(vendor.images.first.thumb.file.path)).to be_truthy
        expect(File.exist?(vendor.avatar.file.path)).to be_truthy
      end
    end

    context 'Successfull GET request with default avatar placeholder' do
      let!(:vendor)   { create(:vendor, images: [uploaded_file('png.png')]) }

      example_request 'Successfull GET request with default avatar placeholder' do
        # ap json(response_body)
        expect(status).to eq(200)
        expect(json(response_body)[:data][:attributes][:avatar]).to match("fallback/vendor/default_vendor_avatar")
      end
    end

  end

end