require 'acceptance_helper'

resource "password_resets", document: :v1 do

  include_context :content_headers

  with_options :scope => :password_reset, :required => true do
    parameter :email, "User email"
  end

  let(:user) { create(:customer) }
  let(:email) { user.email }

  post "/password_resets" do

    response_field "email", "User email, may contain validation errors"
    response_field "user", "User field, may contain error whan email is valid, no user found"

    example_request "Successfull password reset" do
      expect(status).to eq(200)
      expect(response_body).to match(user.email)
      expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
    end

    context 'Responds with error if email is valid but user not found' do
      let(:email) { 'wrong-' + user.email  }

      example_request("Responds with error if email is valid but user not found") do
        expect(status).to eq(422)
        expect(response_body).to match("can't find a user with this email")
      end
    end

    context 'If no email sent' do
      let(:email) { '' }

      example_request("If no email sent") do
        expect(status).to eq(422)
        expect(response_body).to match("is not an email")
      end
    end

    context 'Respond with error if no email malformed' do
      let(:email) { '@email.com' }

      example_request("Respond with error if no email malformed") do
        expect(status).to eq(422)
        expect(response_body).to match("is not an email")
      end
    end

  end
end
