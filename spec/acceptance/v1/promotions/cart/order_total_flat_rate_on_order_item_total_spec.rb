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

  let!(:customer) { create(:signed_in_customer) }
  let!(:token) { "Token token=#{customer.http_token.key}" }

  let!(:promotion) do
    create(:order_total_flat_rate_on_order_item_total)
  end

  let!(:vendor) { promotion.vendors.first }

  let(:order_items) { [
    { :'inventory-item-id' => vendor.inventory_items.first.id, quantity: 3 },
    { :'inventory-item-id' => vendor.inventory_items.last.id, quantity: 1 }
  ] }
  let(:shipping) { { :'shipping-method-id' => vendor.shipping_methods.first.id } }
  let(:order) { { :'order-items' => order_items, shipping: shipping } }

  post '/cart' do
    context 'Flat rate promotion discount given on order item total if order total is in specified range' do
      example_request 'Flat rate promotion discount given on order item total if order total is in specified range' do
        expect(status).to eq(200)
        ap json(response_body)

        expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
        expect(json(response_body)[:data][:attributes][:subtotal]).to eq(5030)
        expect(json(response_body)[:data][:attributes][:total]).to eq(6515)
        expect(json(response_body)[:data][:attributes][:"promotion-amount"]).to eq(-15)
      end
    end
  end
end
