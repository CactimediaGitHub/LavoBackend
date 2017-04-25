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
  let(:tokens) { ['fmdiBxyYomk:APA91bH1riyrQGPYwzZCPQYKZnQJx9wOzJ460aiZ3KlUsIyVbsl70c0soWJkwgeWzmByU2WbjJ910aiy07koz4uUzWwN7Ui__wgCGcaKwJaSIe6460fFSguCn3z75nDuqi-d5dnoAhSl'] }
  let(:message) { 'My super cool message' }
  let(:title) { 'Your Lavo order state changed' }

  post '/notification_messages' do
    include SpecHelpers::VcrDoRequest[:send_push_notification]

    context 'Successfull push notification sending' do
      example_request 'Successfull push notification sending' do
        expect(status).to eq(200)
        expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
        expect(Notification.count).to eq(1)
      end
    end
  end

end