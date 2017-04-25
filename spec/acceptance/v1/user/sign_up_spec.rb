require 'acceptance_helper'

resource "user/sign_up", document: :v1 do

  include_context :content_headers

  context 'Customer create' do
    parameter :type, 'customers', scope: :data, required: true
    with_options scope: [:data, :attributes] do |o|
      o.parameter :email, "User email", required: true
      o.parameter :password, "User password", required: true
      o.parameter :password_confirmation, "Password confirmation", required: true
    end

    post "/signup" do

      context 'Happy path' do
        # let(:email) { 'syber@junkie.com' }
        let(:email) { 'staff1489@gmail.com' }
        let(:password) { '123456' }
        let(:password_confirmation) { '123456' }

        example_request "Successfull customer sign up" do
          expect(status).to eq(201)
          expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
        end
      end

      context 'Validation' do
        let(:email) { 'syber-junkie.com' }
        let(:password) { '' }
        let(:password_confirmation) { '123456' }

        example_request "Validation errors when irrelevant params sent" do
          expect(status).to eq(422)
        end

      end

    end

  end # signup

end