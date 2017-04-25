require 'acceptance_helper'

resource "review/customer_reviews", document: :v1 do

  header 'Authorization', :token
  include_context :content_headers

  parameter :id, 'Customer id', required: true

  let(:review) { create(:review) }
  let(:customer) { review.reviewer.tap { |r| r.update(http_token: HttpToken.new(key: TokenGenerator.uuid)) } }
  let(:token) { "Token token=#{customer.http_token.key}" }
  let(:id) { customer.id }

  get "/customers/:id/reviews" do

    context 'Happy path' do
      example_request "Successfull rendering" do
        expect(status).to eq(200)
        expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
        ap json(response_body)
        expect(json(response_body)[:included][0][:type]).to eq('vendors')
      end
    end

  end

end
