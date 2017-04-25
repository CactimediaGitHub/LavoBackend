require 'acceptance_helper'

resource "admin/promotions/create_promotion_action", document: :v1 do

  header 'Accept', Mime[:html].to_s
  include_context :accept_encoding_header

  parameter :promotion_actions_create_item_adjustment, 'Typical promotion action create item adjustment structure'

  with_options(scope: :promotion_actions_create_item_adjustment, required: true) do |o|
    o.parameter :promotion_id, 'Promotion references'
    o.parameter :type, 'Promotion action type'
    o.parameter :calculator_amount, 'Promotion prefferet discount amount, used by calculator'
    o.parameter :calculator_type, 'Calculator used to calculate the discount'
  end

  let!(:promotion) { create(:active_promotion) }
  let(:calculator_amount) { 1000 }
  let(:calculator_type) { 'Promotion::Calculators::FlatRate' }
  let(:type) { 'Promotion::Actions::CreateAdjustment' }

  post '/admin/promotion/actions/create_item_adjustments' do
    context 'Successfull promotion create item adjustment action creation' do
      let(:promotion_id) { promotion.id }

      example_request 'Successfull promotion create item adjustment action creation' do
        expect(status).to eq(302)
        expect(response_headers['Content-Type']).to match("#{Mime[:html].to_s}; charset=utf-8")
        expect(Promotion.count).to eq(1)
        expect(Promotion.first.actions.count).to eq(1)
        expect(Promotion.first.actions.first.calculator.preferred_amount).to eq(calculator_amount)
      end
    end

    # context 'Validation errors if no promotion choosen' do
    #   let(:promotion_id) { '' }
    #   example_request 'Validation errors if no promotion choosen' do
    #     expect(status).to eq(200)
    #     expect(response_headers['Content-Type']).to match("#{Mime[:html].to_s}; charset=utf-8")
    #     # expect(Promotion.count).to eq(1)
    #     # expect(Promotion.first.actions.count).to eq(0)
    #     # expect(PromotionAction.first.calculator.preferred_amount).to eq(calculator_amount)
    #   end
    # end

  end
end
