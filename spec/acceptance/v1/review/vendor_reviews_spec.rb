require 'acceptance_helper'

resource "review/vendor_reviews", document: :v1 do

  include_context :no_content_headers

  parameter :id, 'Vendor id', required: true

  let(:review) { create(:review) }
  let(:id) { review.reviewable.id }

  get "/vendors/:id/reviews" do

    context 'Happy path' do
      example_request "Successfull rendering" do
        # ap json(response_body)
        expect(status).to eq(200)
        expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
        expect(json(response_body)[:included][0][:type]).to eq('customers')
      end
    end

  end

end