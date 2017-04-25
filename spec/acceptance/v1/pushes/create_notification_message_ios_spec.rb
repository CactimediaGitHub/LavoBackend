require 'acceptance_helper'

resource 'pushes/create notification messages', document: :v1 do
  include_context :content_headers
  header 'Authorization', :token

  parameter :type, 'notification-messages', scope: :data, required: true
  with_options scope: [:data, :attributes], required: true do |o|
    o.parameter :tokens, 'Push notification device token'
    o.parameter :message, 'Push notification message body'
    o.parameter :title, 'Push notification message title'
  end

  let(:customer) { create(:signed_in_customer) }
  let(:token) { "Token token=#{customer.http_token.key}" }

  let(:type) { 'notification-messages' }
  let(:tokens) { ['euXYzS_EBp4:APA91bHRqbrQF80pYB7sATY_3Wku2vbW2uZ8ab6CRSCovvZ6BiA8edxc-KIZdTOsxm0VxN8m8OYKQthGMX8xNzJpmE9rQh4jElzu7ZT_m-m7_jloT-S1FAQiWCFa411fG7OMm79nq7c5'] }
  let(:message) { 'My super cool ios message' }
  let(:title) { 'Your Lavo order state changed' }

  post '/notification_messages' do
    include SpecHelpers::VcrDoRequest[:send_push_notification_ios]

    context 'Successfull push notification sending' do
      example_request 'Successfull push notification sending' do
        expect(status).to eq(200)
        expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
        expect(Notification.count).to eq(1)
      end
    end
  end

end