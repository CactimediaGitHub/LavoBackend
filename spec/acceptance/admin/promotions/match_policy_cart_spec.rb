# require 'acceptance_helper'
#
# resource "order/cart_total", document: :v1 do
#
#   include_context :content_headers
#   header 'Authorization', :token
#
#   parameter :order, 'Typical order structure'
#
#   with_options scope: %i(order order-items), required: true do |o|
#     o.parameter :'inventory-item-id', 'Inventory item id'
#     o.parameter :quantity, 'Purchansed quntity of inventory items'
#   end
#
#   with_options scope: %i(order shipping), required: true do |o|
#     o.parameter :'shipping-method-id', 'Shipping method item id'
#   end
#
#   let(:customer) { create(:signed_in_customer) }
#   let(:token) { "Token token=#{customer.http_token.key}" }
#
#   let(:vendor) { create(:vendor) }
#   let(:inventory_item) { create(:inventory_item_full, vendor: vendor) }
#   let(:inventory_item1) { create(:inventory_item_full, vendor: vendor) }
#   let(:shipping_method) { create(:shipping_method_express, vendor: inventory_item.vendor) }
#
#   let(:order_items) { [{ :'inventory-item-id' => inventory_item.id, quantity: 3 }, { :'inventory-item-id' => inventory_item1.id, quantity: 1 }] }
#   let(:shipping) { { :'shipping-method-id' => shipping_method.id } }
#   let(:order) { { :'order-items' => order_items, shipping: shipping } }
#
#   let!(:calculator1) { create(:calculator_flat_rate, calculator_amount: 100) }
#   let!(:promotion_action_create_adjustment) { create(:promotion_action_create_adjustment, calculator: calculator1) }
#   let!(:promotion_rule_order_item_quantity) do
#     build(:promotion_rule_order_item_quantity,
#            vendor_id: inventory_item.vendor.id,
#          preferences: { :order_item_quantity => 2, service_id: inventory_item.service_id, item_id: inventory_item.item_id })
#   end
#
#   let!(:calculator2) { create(:calculator_percent_on_order_item, preferred_percent: 10) }
#   preferences = { :operator_min => 'gt', :operator_max => 'lt', :amount_min => BigDecimal.new(10), :amount_max => BigDecimal.new(100000) }
#   let!(:order_total_promotion_rule) { build(:order_total_promotion_rule, preferences: preferences) }
#   let!(:promotion_action_create_item_adjustment) { create(:promotion_action_create_item_adjustment, calculator: calculator2) }
#
#   let!(:promotion) { create(:active_promotion,
#                        match_policy: 'all',
#                        promotion_rules: [promotion_rule_order_item_quantity, order_total_promotion_rule],
#                        promotion_actions: [promotion_action_create_adjustment, promotion_action_create_item_adjustment]) }
#
#   post '/cart' do
#     context 'Successfull cart total calculation with several rules and match policy set' do
#       response_field 'subtotal', 'Subtotal'
#       response_field 'total', 'Total'
#       response_field 'promotion_adjustment', 'Promotion adjustment'
#
#       example_request 'Successfull cart total calculation with several rules and match policy set' do
#         # binding.pry
#
#         expect(status).to eq(200)
#         ap json(response_body)
#
#         expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
#         expect(json(response_body)[:data][:attributes][:subtotal]).to eq(4000)
#         expect(json(response_body)[:data][:attributes][:total]).to eq(5400)
#         expect(json(response_body)[:data][:attributes][:"promotion-adjustment"]).to eq(100)
#         expect(json(response_body)[:data][:attributes][:"promotion-amount"]).to eq(-100)
#       end
#     end
#   end
# end