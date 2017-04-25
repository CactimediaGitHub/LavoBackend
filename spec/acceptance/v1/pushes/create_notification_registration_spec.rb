require 'acceptance_helper'

resource 'pushes/notification_registration', document: :v1 do

  let(:customer) { create(:signed_in_customer) }
  let(:http_token) { "Token token=#{customer.http_token.key}" }

  post '/notification_registrations' do
    include_context :content_headers
    header 'Authorization', :http_token

    parameter :type, 'notification-registrations', scope: :data, required: true
    with_options scope: [:data, :attributes], required: true do |o|
      o.parameter :token, 'Push notification device token'
      o.parameter :notify, 'Send notifications? Boolean flag.'
    end
    let(:type) { 'notification-registrations' }
    let(:notify) { 'true' }

    context 'Successfull push notification registration' do
      let(:token) { 'e2w2J0RJTWA:APA91bGXxxHG5uuYyTfa-a71QZSqFXb1tzpdkSWcLMFWCZ64m0eacj7HuFLTjrWJAmAhlkmoII6zjO0asmkslnmEb70p676RoUqwSxjVIDBCW45qabKQWnBGiyaMhGcjFhykU-m9WwEo' }
      example_request 'Successfull push notification registration' do
        expect(status).to eq(201)
        expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
        expect(NotificationRegistration.first.token).to eq(token)
      end
    end

    context 'Successfull push notification registration with existing registration' do
      let(:token) { 'c7vyb2asV9g:APA91bGL9cVDypJRU0cLIQupk19sepkzhcOL33r99ljYbCy6_Qyl5rrIyICATu_z9OZRaHUVK9--mDXeizXqqnll9IKerKgNrum-KQ57zLkT2MFENTqVsNKV5387v-YZAfRdTRbnbdbe' }
      let!(:registration) {create(:notification_registration, notifiable: customer, token: token)}

      example_request 'Successfull push notification registration with existing registration' do
        expect(status).to eq(201)
        expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
        expect(NotificationRegistration.count).to eq(1)
        expect(NotificationRegistration.first.token).to eq(token)
      end
    end

    context 'Push notification registration with existing token for different customer' do
      let(:token) { 'c7vyb2asV9g:APA91bGL9cVDypJRU0cLIQupk19sepkzhcOL33r99ljYbCy6_Qyl5rrIyICATu_z9OZRaHUVK9--mDXeizXqqnll9IKerKgNrum-KQ57zLkT2MFENTqVsNKV5387v-YZAfRdTRbnbdbe' }
      let(:customer1) { create(:customer) }
      let!(:registration) {create(:notification_registration, notifiable: customer1, token: token)}

      example_request 'Push notification registration with existing token for different customer' do
        expect(status).to eq(422)
        ap json(response_body)
        expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
        expect(NotificationRegistration.count).to eq(1)
        expect(NotificationRegistration.first.notifiable).to eq(customer1)
      end
    end


    context 'Validation error if push notification registration token is blank' do
      let(:type) { 'notification-registrations' }
      let(:token) { nil }
      let(:notify) { 'true' }

      example_request 'Validation error if push notification registration token is blank' do
        expect(status).to eq(422)
        ap json(response_body)
        expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
        expect(NotificationRegistration.count).to eq(0)
      end
    end

  end

  # delete '/notification_registrations/:id' do
  #   include_context :no_content_headers
  #
  #   context 'Remove push notification token from backend db' do
  #
  #     parameter :id, 'Push notification device token', required: true
  #
  #     let(:registration) {create(:notification_registration, notifiable: customer)}
  #     let(:id) { registration.token }
  #
  #     example_request 'Remove push notification token from backend db' do
  #       expect(status).to eq(204)
  #       # expect(NotificationRegistration.count).to eq(0)
  #     end
  #   end
  # end

end