require 'acceptance_helper'

resource 'pushes/list notification messages', document: :v1 do
  include_context :no_content_headers
  header 'Authorization', :token

  let(:customer) { create(:signed_in_customer) }
  let(:token) { "Token token=#{customer.http_token.key}" }

  let!(:notifications) { create_list(:notification, 22, notifiable: customer) }

  get '/notification_messages' do

    context 'Successfull push notification listing' do
      example_request 'Successfull push notification sending' do
        expect(status).to eq(200)
        expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
      end
    end
  end

end