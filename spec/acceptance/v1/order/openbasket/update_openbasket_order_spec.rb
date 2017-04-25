require 'acceptance_helper'

resource "order/openbasket update order", document: :v1 do

  include_context :content_headers
  header 'Authorization', :token

  parameter :order, 'Open basket order structure'

  with_options scope: %i(order shipping), required: true do |o|
    o.parameter :'shipping-method-id', 'Shipping method item id'
  end

  with_options scope: %i(order order-items), required: true do |o|
    o.parameter :'inventory-item-id', 'Inventory item id'
    o.parameter :quantity, 'Purchansed quntity of inventory items'
  end


  let(:customer) { create(:signed_in_customer) }
  let(:token) { "Token token=#{customer.http_token.key}" }
  let(:vendor) { create(:vendor) }
  let!(:shipping_method) { create(:shipping_method_express, vendor: vendor, shipping_charge: 1210) }

  let(:openbasket_order) { create(:openbasket_order, vendor: vendor, customer: customer).tap { |o| o.state_machine.transition_to(:pending); o.state_machine.transition_to(:updating) }}

  let(:inventory_item) { create(:inventory_item_full, vendor: vendor, price: 1030) }
  let(:order_items) { [{ :'inventory-item-id' => inventory_item.id, quantity: 3 }] }

  let(:shipping) { { :'shipping-method-id' => vendor.shipping_methods.first.id } }

  let(:order) { { :'order-items' => order_items, shipping: shipping } }
  let(:id) { openbasket_order.id }


  # let!(:notification_registration) {
  #   create :notification_registration,
  #          notify: true,
  #          token: 'fv6BNsXkW4M:APA91bEJGOUzOgGlS_OyU90Av6lDI68AMMIW3rOiCIweYXdwePRcFSYmTQ70R23fCpl7WXTGpH9fsAWTgAMUUu7vSf1anYtlTf5NkldeIn5-ftsCh8nwHItZtXXLhSLtgsyeu-6XTiLD',
  #          notifiable: vendor
  # }


  patch '/openbasket_orders/:id' do
    # include SpecHelpers::VcrDoRequest[:create_order]

    context 'Successfull order update' do
      example_request 'Successfull order update' do
        ap json(response_body)
        expect(status).to eq(200)
        expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
        expect(json(response_body)[:data][:attributes][:total]).to eq(0)
        expect(json(response_body)[:data][:attributes][:state]).to eq('approving')

        expect(json(response_body)[:data][:relationships][:vendor][:data][:id]).to eq(vendor.id.to_s)
        expect(json(response_body)[:data][:relationships][:customer][:data][:id]).to eq(customer.id.to_s)

        expect(json(response_body)[:data][:relationships][:shipping][:data][:id]).to eq(Shipping.last.id.to_s)

        expect(json(response_body)[:data][:relationships][:'order-items'][:data].size).to eq(1)
        expect(json(response_body)[:data][:relationships][:'order-items'][:data][0][:id]).to eq(OrderItem.last.id.to_s)

        expect(json(response_body)[:included][0][:attributes][:'pick-up']).to be_present
        expect(json(response_body)[:included][0][:attributes][:'drop-off']).to be_present

        expect(json(response_body)[:included][1][:attributes][:quantity]).to eq(3)
        expect(json(response_body)[:included][1][:relationships][:'inventory-item'][:data][:id]).to eq(inventory_item.id.to_s)
        expect(Notification.count).to eq(3)
        expect(Notification.first.notifiable).to eq(vendor)
      end
    end

  end

end