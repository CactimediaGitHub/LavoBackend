require 'acceptance_helper'

resource "order/openbasket create order", document: :v1 do

  include_context :content_headers
  header 'Authorization', :token

  parameter :order, 'Open basket order structure'

  with_options scope: %i(order shipping), required: true do |o|
    o.parameter :'address-id', 'Customer shipping address'
    o.parameter :'pick-up', 'Order pick up time'
    o.parameter :'drop-off', 'Order drop off time'
  end

  let(:vendor) { create(:vendor) }
  let(:customer) { create(:signed_in_customer) }
  let(:token) { "Token token=#{customer.http_token.key}" }

  let(:address) { create(:address, customer: customer) }
  let(:shipping) {
    { :'address-id' => address.id,
      :'pick-up' => "[#{Time.now}, #{Time.now + 2.hours}]",
      :'drop-off' => "[#{Time.now + 8.hours}, #{Time.now + 8.hours + 2.hours}]" }
  }

  # let!(:notification_registration) {
  #   create :notification_registration,
  #          notify: true,
  #          token: 'fv6BNsXkW4M:APA91bEJGOUzOgGlS_OyU90Av6lDI68AMMIW3rOiCIweYXdwePRcFSYmTQ70R23fCpl7WXTGpH9fsAWTgAMUUu7vSf1anYtlTf5NkldeIn5-ftsCh8nwHItZtXXLhSLtgsyeu-6XTiLD',
  #          notifiable: vendor
  # }

  let(:order) { { :'vendor-id' => vendor.id, shipping: shipping } }

  post "/openbasket_orders" do
    # include SpecHelpers::VcrDoRequest[:create_openbasket_order]

    context 'Successfull order placement' do
      example_request 'Successfull order placement' do
        ap json(response_body)
        expect(status).to eq(201)
        expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
        expect(json(response_body)[:data][:attributes][:total]).to eq(0)
        expect(json(response_body)[:data][:attributes][:state]).to eq('pending')
        expect(json(response_body)[:data][:attributes][:openbasket]).to be_truthy

        expect(json(response_body)[:data][:relationships][:vendor][:data][:id]).to eq(vendor.id.to_s)
        expect(json(response_body)[:data][:relationships][:customer][:data][:id]).to eq(customer.id.to_s)

        expect(json(response_body)[:data][:relationships][:shipping][:data][:id]).to eq(Shipping.last.id.to_s)
        expect(json(response_body)[:data][:relationships][:'order-items'][:data].size).to eq(0)

        expect(json(response_body)[:included][0][:attributes][:'pick-up']).to be_present
        expect(json(response_body)[:included][0][:attributes][:'drop-off']).to be_present

        expect(json(response_body)[:included][1][:attributes][:address1]).to eq(address.address1)
        expect(json(response_body)[:included][1][:attributes][:address2]).to eq(address.address2)
        expect(json(response_body)[:included][1][:attributes][:city]).to eq(address.city)
        expect(json(response_body)[:included][1][:attributes][:country]).to eq(address.country)
        expect(json(response_body)[:included][1][:attributes][:nearest_landmark]).to eq(address.nearest_landmark)
        expect(json(response_body)[:included][1][:attributes][:'human-name']).to eq(address.human_name)

        expect(Notification.count).to eq(1)
        expect(Notification.first.notifiable).to eq(vendor)
      end
    end

  end

end