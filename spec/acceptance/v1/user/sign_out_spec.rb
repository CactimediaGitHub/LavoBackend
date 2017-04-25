require 'acceptance_helper'

resource "signout", document: :v1 do

  include_context :content_headers

  delete "/signout" do

    context 'Successfull signout' do
      let(:user) { create(:customer, http_token: HttpToken.new(key: TokenGenerator.uuid)) }
      let(:token) { "Token token=#{user.http_token.key}" }

      header 'Authorization', :token

      example_request "Successfull signout" do
        expect(status).to eq(204)
        expect(user.reload.http_token).to be nil
      end
    end

  end

end