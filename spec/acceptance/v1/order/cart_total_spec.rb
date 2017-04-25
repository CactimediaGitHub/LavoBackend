require 'acceptance_helper'

resource "order/cart_total", document: :v1 do

  include_context :content_headers
  header 'Authorization', :token

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

  let(:inventory_item) { create(:inventory_item_full) }
  let(:shipping_method) { create(:shipping_method_express, vendor: inventory_item.vendor) }

  post "/cart" do
    context 'Successfull cart total calculation' do
      let(:order_items) { [{ :'inventory-item-id' => inventory_item.id, quantity: 3 }] }
      let(:shipping) { { :'shipping-method-id' => shipping_method.id } }
      let(:order) { { :'order-items' => order_items, shipping: shipping } }

      response_field 'subtotal', 'Subtotal'
      response_field 'total', 'Total'
      response_field 'promotion_adjustment', 'Promotion adjustment'

      example_request 'Successfull cart total calculation' do
        expect(status).to eq(200)
        ap json(response_body)

        expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
        expect(json(response_body)[:data][:attributes][:subtotal]).to eq(3000)
        expect(json(response_body)[:data][:attributes][:total]).to eq(4500)
        expect(json(response_body)[:data][:attributes][:"promotion-amount"]).to eq(0)
      end
    end

    context 'Cart total with validation errors' do
      let(:order_items) { [] }
      let(:shipping) { {} }
      let(:order) { { :'order-items' => order_items, shipping: shipping } }

      example_request 'Cart total with validation errors' do
        expect(status).to eq(422)
        ap json(response_body)

        expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
      end
    end


  end
end
