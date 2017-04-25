require 'acceptance_helper'

resource "user_activation", document: :v1 do

  include_context :no_content_headers

  parameter :id, "Activation token sent via email activation link", required: true
  parameter :email, :required => true

  let(:user) { create(:inactive_customer) {|c| c.update_column(:activation_digest, API::User::Concerns::Digest.digest("ab12")) } }
  let(:id) { 'ab12' }
  let(:email) { user.email }

  get "/activations/:id/edit" do

    context 'Successfull user activation' do
      example_request "Successfull user activation" do
        # ap response_body
        expect(status).to eq(200)
        # expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
        expect(user.reload.http_token.key).to be_present
      end
    end

    context "Respond with error if token don't match digest" do
      let(:id) { 'wrong-ab12' }

      example_request "Respond with error if token don't match digest" do
        # ap response_body
        expect(status).to eq(422)
        expect(response_body).to match("is invalid")
        expect(user.http_token).to be_nil
      end
    end

    context "Respond with error if user already activated" do
      before do
        user.update_column(:activated, true)
      end

      example_request "Respond with error if user already activated" do
        # ap response_body
        expect(status).to eq(422)
        expect(response_body).to match("already activated")
      end
    end
  end

end