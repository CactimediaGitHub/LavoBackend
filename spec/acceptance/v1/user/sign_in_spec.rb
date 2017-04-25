require 'acceptance_helper'

resource "signin", document: :v1 do

  include_context :content_headers

  parameter :type, 'signin', scope: :data, required: true
  with_options scope: [:data, :attributes], required: true do |o|
    o.parameter :email, "User email"
    o.parameter :password, "User password"
  end

  let(:user) { create(:customer, activated: true, email: 'syber@junkie.com') }
  let(:email) { user.email.upcase }
  let(:password) { user.password }
  let(:type) { 'signin' }

  post "/signin" do

    context 'Successfull signin customer' do
      response_field 'http_token[key]', "HTTP authentication token"

      example_request 'Successfull signin customer' do
        expect(status).to eq(200)
        expect(response_body).to match(user.email)
        expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
        rb = JSON.parse(response_body)
        expect(rb["included"][0]['attributes']['key']).to be_present
        expect(user.reload.http_token.key).to be_present
      end
    end

    context 'Successfull signin vendor' do
      response_field 'http_token[key]', "HTTP authentication token"

      let(:user) { create(:vendor, activated: true, email: 'laundry@dubai.com') }


      example_request 'Successfull signin vendor' do
        expect(status).to eq(200)
        expect(response_body).to match(user.email)
        expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
        rb = JSON.parse(response_body)
        expect(rb["included"][0]['attributes']['key']).to be_present
        expect(user.reload.http_token.key).to be_present
      end
    end


    context 'Errors' do
      context 'Failed signin with wrong password' do
        let(:password) { '123456-wrong' }

        example_request("Signin with wrong password") do
          expect(status).to eq(401)
          expect(response_body).to match(/Invalid login credentials/)
        end
      end

      context 'Failed signin with wrong email' do
        let(:email) { 'wrong-' + user.email  }

        example_request("Signin with wrong email") do
          expect(status).to eq(401)
          expect(response_body).to match(/Invalid login credentials/)
        end
      end

      context 'Respond with error if user not activated' do
        let(:user) { create(:inactive_customer) }

        example_request("Respond with error if user not activated") do
          expect(status).to eq(401)
          expect(response_body).to match(/isn't activated/)
        end
      end

    end


  end
end
