require 'acceptance_helper'

resource "admin/promotions/create_promotion_rule", document: :v1 do

  header 'Accept', Mime[:html].to_s
  include_context :accept_encoding_header

  parameter :promotion_rule, 'Typical promotion structure'

  with_options(scope: :promotion_rules_order_total, required: true) do |o|
    o.parameter :promotion_id, 'Promotion references'
    o.parameter :preferred_operator_min, 'Min operator'
    o.parameter :preferred_amount_min, 'Min amount, AED'
    o.parameter :preferred_operator_max, 'Max operator'
    o.parameter :preferred_amount_max, 'Max amount, AED'
  end

  let(:promotion) { create(:active_promotion) }
  let(:promotion_id) { promotion.id }
  let(:type) { 'Promotion::Rules::OrderTotal' }
  let(:preferred_operator_min) { 'gt' }
  let(:preferred_amount_min) { '99.00' }
  let(:preferred_operator_max) { 'lt' }
  let(:preferred_amount_max) { '101.00' }

  post '/admin/promotion/rules/order_totals' do

    context 'Successfull Order Total promotion rule creation' do
      example_request 'Successfull promotion rule creation' do
        expect(status).to eq(302)
        expect(response_headers['Content-Type']).to match("#{Mime[:html].to_s}; charset=utf-8")
        expect(PromotionRule.count).to eq(1)
      end
    end
  end
end
