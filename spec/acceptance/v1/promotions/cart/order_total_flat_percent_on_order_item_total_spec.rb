require 'acceptance_helper'

resource "order/cart_total", document: :v1 do

  include_context :content_headers
  header 'Authorization', :token

  response_field 'subtotal', 'Order subtotal'
  response_field 'promotion_amount', 'Negative promotion amount'
  response_field 'total', 'Order total including promotion amount'

  parameter :order, 'Typical order structure'

  with_options scope: %i(order order-items), required: true do |o|
    o.parameter :'inventory-item-id', 'Inventory item id'
    o.parameter :quantity, 'Purchansed quntity of inventory items'
  end

  with_options scope: %i(order shipping), required: true do |o|
    o.parameter :'shipping-method-id', 'Shipping method item id'
  end

  let(:customer) { create(:signed_in_customer) }
  let(:token) { "Token token=#{customer.http_token.key}" }

  let(:vendor) { create(:vendor) }
  let!(:inventory_item) { create(:inventory_item_full, vendor: vendor) }
  let!(:inventory_item1) { create(:inventory_item_full, vendor: vendor) }
  let(:order_items) { [
    { :'inventory-item-id' => inventory_item.id, quantity: 3 },
    { :'inventory-item-id' => inventory_item1.id, quantity: 1 }
  ] }
  let(:shipping_method) { create(:shipping_method_express, vendor: vendor) }
  let(:shipping) { { :'shipping-method-id' => shipping_method.id } }
  let(:order) { { :'order-items' => order_items, shipping: shipping } }

  let!(:vendor1) { create(:vendor) }
  let!(:inventory_item2) do
    create(:inventory_item,
      service: inventory_item.service,
         item: inventory_item.item,
    item_type: inventory_item.item_type,
          vendor: vendor1)
  end

  let!(:promotion) { create(:order_total_flat_percent_on_order_item_total, vendors: [vendor, vendor1]) }

  post '/cart' do
    context 'Fixed percent promotion discount given on order item total if order total is in specified range' do
      example_request 'Fixed percent promotion discount given on order item total if order total is in specified range' do
        expect(status).to eq(200)
        ap json(response_body)

        expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
        expect(json(response_body)[:data][:attributes][:subtotal]).to eq(4000)
        expect(json(response_body)[:data][:attributes][:total]).to eq(4900)
        expect(json(response_body)[:data][:attributes][:"promotion-amount"]).to eq(-600)
      end
    end
  end
end
