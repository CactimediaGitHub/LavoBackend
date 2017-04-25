require 'acceptance_helper'

resource "review/comments", document: :v1 do
  let(:review) { create(:review) }
  let(:vendor) { review.reviewer.tap { |r| r.update(http_token: HttpToken.new(key: TokenGenerator.uuid)) } }
  let(:token) { "Token token=#{vendor.http_token.key}" }

  header 'Authorization', :token
  include_context :content_headers

  before do
    Review.send(:include, ReviewExtention)
  end

  context 'create' do
    parameter :type, 'comments', scope: :data, required: true
    with_options scope: [:data, :attributes] do |o|
      o.parameter :reviewable_type, "'Review' string", required: true
      o.parameter :reviewable_id, "Review id", required: true
      o.parameter :reviewer_type, "'Customer/Vendor' string", required: true
      o.parameter :reviewer_id, "Customer/Vendor id", required: true
      o.parameter :body, "Comment message", required: true
    end

    post "/reviews/:id/comments" do

      context 'Happy path' do
        let(:id) { review.id }
        let(:reviewable_type) { 'Review'}
        let(:reviewable_id) { review.id }
        let(:reviewer_type) { 'Vendor' }
        let(:reviewer_id) { vendor.id }
        let(:body) { "Blah" }

        example_request "Successfull review comment creation" do
          expect(status).to eq(201)
          expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
          ap json(response_body)
        end
      end

      context 'Validation' do
        let(:id) { review.id }
        let(:reviewable_type) { ''}
        let(:reviewable_id) { nil }
        let(:reviewer_type) { 'Blah' }
        let(:reviewer_id) { 222 }
        let(:rating) { 50 }

        example_request "Validation errors" do

          expect(status).to eq(422)
        end

      end

    end

  end # create

  context 'destroy' do
    let(:comment) { review.comments.first }
    let(:id) { comment.id }
    let(:review_id) { review.id }

    delete "/reviews/:review_id/comments/:id" do
      example_request "Remove comment" do
        expect(status).to eq(204)
      end
    end

  end # destroy

  context 'update' do
    let(:comment) { review.comments.first }
    let(:id) { comment.id }
    let(:review_id) { review.id }

    with_options scope: [:data, :attributes] do |o|
      o.parameter :body, "Comment message body", required: true
    end

    patch "/reviews/:review_id/comments/:id" do

      context 'successfull' do
        let(:body) { 'New blah' }
        example_request 'Successfull comment update' do
          expect(status).to eq(200)
          expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
          expect(comment.reload.body).to eq(body)
        end
      end

      context 'validation errors' do
        let(:body) { '' }
        example_request "Validation errors while updating comment" do
          expect(status).to eq(422)
          expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
        end
      end

    end

  end # update

end
