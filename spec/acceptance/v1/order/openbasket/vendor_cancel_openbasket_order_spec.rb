require 'acceptance_helper'

resource "order/openbasket vendor cancel order", document: :v1 do

  include_context :content_headers
  header 'Authorization', :token

  parameter :id, 'Order id', required: true
  parameter :state, 'New order state', required: true

  let(:vendor) { create(:signed_in_vendor) }
  let(:token) { "Token token=#{vendor.http_token.key}" }

  let!(:shipping_mentod) { create(:shipping_method_normal, vendor: vendor) }

  let(:customer) { create(:customer) }

  let!(:notification_registration) {
    create :notification_registration,
           notify: true,
           token: 'fv6BNsXkW4M:APA91bEJGOUzOgGlS_OyU90Av6lDI68AMMIW3rOiCIweYXdwePRcFSYmTQ70R23fCpl7WXTGpH9fsAWTgAMUUu7vSf1anYtlTf5NkldeIn5-ftsCh8nwHItZtXXLhSLtgsyeu-6XTiLD',
           notifiable: customer
  }

  let(:order) { create(:openbasket_order, vendor: vendor, customer: customer) }
  let(:id) { order.id }

  patch '/order_states/:id' do
    include SpecHelpers::VcrDoRequest[:vendor_cancels_openbasket_order]

    context 'Vendor successfully cancels order' do
      let(:state) { 'cancelled' }

      example_request 'Vendor successfully cancels order' do
        ap json(response_body)
        expect(status).to eq(200)
        expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
        expect(json(response_body)[:data][:attributes][:state]).to match('cancelled')
      end
    end
  end
end
