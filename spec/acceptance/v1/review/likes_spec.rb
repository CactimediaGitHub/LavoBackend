require 'acceptance_helper'

resource "review/likes", document: :v1 do
  let(:review) { create(:review) }
  let(:customer) { review.reviewer.tap { |r| r.update(http_token: HttpToken.new(key: TokenGenerator.uuid)) } }
  let(:vendor) { create(:signed_in_vendor) }
  let(:token) { "Token token=#{customer.http_token.key}" }

  header 'Authorization', :token

  context 'create' do
    include_context :content_headers

    parameter :type, 'likes', scope: :data, required: true
    with_options scope: [:data, :attributes] do |o|
      o.parameter :reviewable_type, "'Review' string", required: true
      o.parameter :reviewable_id, "Review id", required: true
      o.parameter :reviewer_type, "'Customer' or 'Vendor' string", required: true
      o.parameter :reviewer_id, "Customer id or Vendor id", required: true
      o.parameter :rating, "1.0", required: true
    end

    post "/reviews/:id/likes" do

      context 'Happy path' do
        let(:id) { review.id }
        let(:type) { 'likes' }
        let(:reviewable_type) { 'Review'}
        let(:reviewable_id) { review.id }
        let(:rating) { 1.0 }

        context 'Review liked by  Customer' do
          let(:reviewer_type) { 'Customer' }
          let(:reviewer_id) { customer.id }

          example_request "Review liked by Customer" do
            ap json(response_body)
            expect(status).to eq(201)
            expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
          end
        end

        context 'Review liked by Vendor' do
          let(:reviewer_type) { 'Vendor' }
          let(:reviewer_id) { vendor.id }

          example_request "Review liked by Vendor" do
            ap json(response_body)
            expect(status).to eq(201)
            expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
          end
        end
      end

      context 'Validation' do
        let(:id) { review.id }
        let(:type) { 'likes' }
        let(:reviewable_type) { '' }
        let(:reviewable_id) { nil }
        let(:reviewer_type) { '' }
        let(:reviewer_id) { 222 }
        let(:rating) { 50.0 }

        example_request "Validation errors when irrelevant params sent" do
          # ap json(response_body)
          expect(status).to eq(422)
        end

      end

    end

  end # create

  context 'destroy' do
    include_context :no_content_headers

    delete "/reviews/:review_id/likes" do
      let(:review_id) { review.id }

      example_request "Unlike" do
        expect(status).to eq(204)
      end
    end

  end # destroy

end