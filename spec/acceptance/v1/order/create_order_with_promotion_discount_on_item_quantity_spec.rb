require 'acceptance_helper'

resource "order/order_placement", document: :v1 do

  include_context :content_headers
  header 'Authorization', :token

  parameter :order, 'Typical order structure'

  with_options scope: %i(order), required: true do |o|
    o.parameter :'vendor-id', 'Vendor id'
  end

  with_options scope: %i(order order-items), required: true do |o|
    o.parameter :'inventory-item-id', 'Inventory item id'
    o.parameter :quantity, 'Purchansed quntity of inventory items'
  end

  with_options scope: %i(order shipping), required: true do |o|
    o.parameter :'address-id', 'Customer shipping address'
    o.parameter :'shipping-method-id', 'Shipping method item id'
    o.parameter :'pick-up', 'Order pick up time'
    o.parameter :'drop-off', 'Order drop off time'
  end

  let(:customer) { create(:signed_in_customer) }
  let(:token) { "Token token=#{customer.http_token.key}" }

  let(:vendor) { create(:vendor) }
  let(:inventory_item) { create(:inventory_item_full, vendor: vendor, price: 1030) }
  let(:order_items) { [{ :'inventory-item-id' => inventory_item.id, quantity: 3 }] }

  let(:shipping_method) { create(:shipping_method_express, vendor: vendor, shipping_charge: 1210) }
  let(:address) { create(:address, customer: customer) }
  let(:shipping) {
    { :'shipping-method-id' => shipping_method.id,
      :'address-id' => address.id,
      :'pick-up' => "[#{Time.now}, #{Time.now + 2.hours}]",
      :'drop-off' => "[#{Time.now + 8.hours}, #{Time.now + 8.hours + 2.hours}]" }
  }

  let!(:notification_registration) {
    create :notification_registration,
           notify: true,
           token: 'fv6BNsXkW4M:APA91bEJGOUzOgGlS_OyU90Av6lDI68AMMIW3rOiCIweYXdwePRcFSYmTQ70R23fCpl7WXTGpH9fsAWTgAMUUu7vSf1anYtlTf5NkldeIn5-ftsCh8nwHItZtXXLhSLtgsyeu-6XTiLD',
           notifiable: vendor
  }

  let(:order) { { :'vendor-id' => vendor.id, :'order-items' => order_items, shipping: shipping } }

  # let(:calculator) { build(:calculator_flat_rate, preferred_amount: 100) }
  # let(:promotion_action_create_adjustment) { build(:promotion_action_create_adjustment, calculator: calculator) }
  #
  # let(:promotion_rule_order_item_quantity) do
  #   build(:promotion_rule_order_item_quantity,
  #        preferences: { order_item_quantity: 2,
  #                                service_id: inventory_item.service_id,
  #                                   item_id: inventory_item.item_id,
  #                              item_type_id: inventory_item.item_type_id })
  # end
  #
  #
  # let!(:promotion) { create(:active_promotion,
  #                      vendors: [vendor],
  #                      promotion_rules: [promotion_rule_order_item_quantity],
  #                      promotion_actions: [promotion_action_create_adjustment]) }

  let!(:promotion) { create(:promotion_with_item_quantity_flat_rate_discount_on_order_total, vendors: [vendor]) }

  post "/orders" do
    include SpecHelpers::VcrDoRequest[:create_order]

    context 'Successfull order placement with promotion discount on item quantity' do
      example_request 'Successfull order placement with promotion discount on item quantity' do
        # binding.pry

        ap json(response_body)
        expect(status).to eq(201)
        expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
        expect(json(response_body)[:data][:attributes][:total]).to eq(4150)
        expect(json(response_body)[:data][:attributes][:state]).to eq('unpaid')
        expect(json(response_body)[:data][:attributes][:subtotal]).to eq(3090)
        expect(json(response_body)[:data][:attributes][:"promotion-amount"]).to eq(-150)

        expect(json(response_body)[:data][:relationships][:vendor][:data][:id]).to eq(vendor.id.to_s)
        expect(json(response_body)[:data][:relationships][:customer][:data][:id]).to eq(customer.id.to_s)

        expect(json(response_body)[:data][:relationships][:shipping][:data][:id]).to eq(Shipping.last.id.to_s)

        expect(json(response_body)[:data][:relationships][:'order-items'][:data].size).to eq(1)
        expect(json(response_body)[:data][:relationships][:'order-items'][:data][0][:id]).to eq(OrderItem.last.id.to_s)

        expect(json(response_body)[:included][1][:attributes][:address1]).to eq(address.address1)
        expect(json(response_body)[:included][1][:attributes][:address2]).to eq(address.address2)
        expect(json(response_body)[:included][1][:attributes][:city]).to eq(address.city)
        expect(json(response_body)[:included][1][:attributes][:country]).to eq(address.country)
        expect(json(response_body)[:included][1][:attributes][:nearest_landmark]).to eq(address.nearest_landmark)
        expect(json(response_body)[:included][1][:attributes][:'human-name']).to eq(address.human_name)

        expect(json(response_body)[:included][0][:attributes][:'pick-up']).to be_present
        expect(json(response_body)[:included][0][:attributes][:'drop-off']).to be_present

        expect(json(response_body)[:included][2][:attributes][:quantity]).to eq(3)
        expect(json(response_body)[:included][2][:relationships][:'inventory-item'][:data][:id]).to eq(inventory_item.id.to_s)
      end
    end

  end

end