require 'acceptance_helper'

resource "password_generation", document: :v1 do

  include_context :no_content_headers

  parameter :id, "User password reset token", :required => true

  let(:user) do
    create(:customer,
      reset_digest: "ad20e7b4803f4e3fa490fb1e2311304b",
      reset_sent_at: Time.zone.now)
  end
  let(:id) { user.reset_digest }

  get "/password_resets/:id/edit" do
    context 'Successfull password generation' do
      example_request "Successfull password generation" do
        expect(status).to eq(200)
        # expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
      end
    end

    context "Reset digest not found" do
      response_field "user", "Contain validation errors for password reset token"

      let(:id) { user.reset_digest + "fake" }

      example_request "Reset digest not found" do
        expect(status).to eq(422)
        expect(response_body).to match("can't find a user by password reset token")
      end
    end

    context "Reset digest expired" do
      response_field "reset_digest", "Contain validation errors for password reset token"

      let(:user) do
        create(:customer,
          reset_digest: "ad20e7b4803f4e3fa490fb1e2311304b",
          reset_sent_at: 3.hour.ago - 5.minute)
      end

      example_request "Reset digest expired" do
        expect(status).to eq(422)
        expect(response_body).to match("password reset token expired")
      end
    end

  end #get
end
