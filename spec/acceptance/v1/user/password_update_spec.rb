require 'acceptance_helper'

resource "password_update", document: :v1 do

  include_context :content_headers
  header 'Authorization', :token

  with_options(scope: :password_reset, :required => true) do |o|
    o.parameter :password, 'User new password'
    o.parameter :password_confirmation, 'User new password confirmation'
  end

  patch "/password_resets/" do
    let(:user) { create(:signed_in_customer) }
    let(:token) { "Token token=#{user.http_token.key}" }

    let(:password) { "123456" }
    let(:password_confirmation) { "123456" }

    context 'Successfull password update' do
      example_request "Successfull password update" do
        expect(status).to eq(200)
        expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
      end
    end

    context 'Validation errors' do
      context 'Respond with error if token invalid' do
        let(:random_token) { create(:http_token) }
        let(:token) { "Token token=#{random_token.key}" }

        example_request "Respond with error if token invalid" do
          expect(status).to eq(401)
          expect(response_body).to match("Invalid login credentials")
        end
      end

      context "Respond with error if password don't match confirmation" do
        let(:password_confirmation) { "wrong" }

        example_request "Respond with error if password don't match confirmation" do
          expect(status).to eq(422)
          expect(response_body).to match("doesn't match")
        end
      end

      context "Respond with error if password empty" do
        let(:password) { "" }
        let(:password_confirmation) { "" }

        example_request "Respond with error if password empty" do
          expect(status).to eq(422)
          expect(response_body).to match("can't be blank")
        end
      end

      context "Respond with error if password too short" do
        let(:password) { "123" }
        let(:password_confirmation) { "123" }

        # FIXME: remove empty email error field
        example_request "Respond with error if password too short" do
          expect(status).to eq(422)
          expect(response_body).to match("is too short")
        end
      end
    end # Validation errors

  end
end
