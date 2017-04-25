require 'acceptance_helper'

resource "admin/promotions/create_promotion_action", document: :v1 do

  header 'Accept', Mime[:html].to_s
  include_context :accept_encoding_header

  parameter :promotion_actions_create_adjustment, 'Typical promotion action create adjustment structure'

  with_options(scope: :promotion_actions_create_adjustment, required: true) do |o|
    o.parameter :promotion_id, 'Promotion references'
    o.parameter :type, 'Promotion action type'
    o.parameter :calculator_amount, 'Promotion prefferet discount amount, used by calculator'
    o.parameter :calculator_type, 'Calculator used to calculate the discount'
  end

  let(:promotion) { create(:active_promotion) }
  let(:promotion_id) { promotion.id }
  let(:calculator_amount) { 1000 }
  let(:calculator_type) { 'Promotion::Calculators::FlatRate' }
  let(:type) { 'Promotion::Actions::CreateAdjustment' }

  post '/admin/promotion/actions/create_adjustments' do
    context 'Successfull promotion create adjustment action creation' do
      example_request 'Successfull promotion create adjustment action creation' do
        expect(status).to eq(302)
        expect(response_headers['Content-Type']).to match("#{Mime[:html].to_s}; charset=utf-8")
        expect(Promotion.count).to eq(1)
        expect(Promotion.first.actions.count).to eq(1)
        expect(Promotion.first.actions.first.calculator.preferred_amount).to eq(calculator_amount)
      end
    end
  end
end
