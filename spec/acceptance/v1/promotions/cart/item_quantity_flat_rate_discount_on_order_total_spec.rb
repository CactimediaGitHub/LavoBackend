require 'acceptance_helper'

resource "order/cart_total", document: :v1 do

  include_context :content_headers
  header 'Authorization', :token

  response_field 'subtotal', 'Subtotal'
  response_field 'total', 'Total'
  response_field 'promotion_adjustment', 'Promotion adjustment'

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
  let(:inventory_item) { create(:inventory_item_full, vendor: vendor) }
  let(:inventory_item1) { create(:inventory_item_full, vendor: vendor) }
  let(:shipping_method) { create(:shipping_method_express, vendor: vendor) }

  let(:shipping) { { :'shipping-method-id' => shipping_method.id } }
  let(:order) { { :'order-items' => order_items, shipping: shipping } }

  post '/cart' do
    context 'Flat rate promotion discount given if order item quantity is greater or equal to specified value' do
      let(:order_items) { [{ :'inventory-item-id' => inventory_item.id, quantity: 3 }, { :'inventory-item-id' => inventory_item1.id, quantity: 1 }] }
      let!(:promotion) { create(:promotion_with_item_quantity_flat_rate_discount_on_order_total, vendors: [vendor]) }

      example_request 'Flat rate promotion discount given if order item quantity is greater or equal to specified value' do
        expect(status).to eq(200)
        ap json(response_body)

        expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
        expect(json(response_body)[:data][:attributes][:subtotal]).to eq(4000)
        expect(json(response_body)[:data][:attributes][:total]).to eq(5350)
        expect(json(response_body)[:data][:attributes][:"promotion-amount"]).to eq(-150)
      end
    end
  end

  post '/cart' do
    context 'Should not give flat rate promotion discount given if order item quantity less to specified value' do
      let(:order_items) { [{ :'inventory-item-id' => inventory_item1.id, quantity: 1 }] }
      let!(:promotion) { create(:promotion_with_item_quantity_flat_rate_discount_on_order_total, vendors: [vendor]) }

      example_request 'Should not give flat rate promotion discount given if order item quantity less to specified value' do
        expect(status).to eq(200)
        ap json(response_body)

        expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
        expect(json(response_body)[:data][:attributes][:subtotal]).to eq(1000)
        expect(json(response_body)[:data][:attributes][:total]).to eq(2500)
        expect(json(response_body)[:data][:attributes][:"promotion-amount"]).to eq(0)
      end
    end
  end

end