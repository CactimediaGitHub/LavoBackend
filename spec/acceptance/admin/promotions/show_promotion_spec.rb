require 'acceptance_helper'

resource "admin/promotions/create_promotion", document: :v1 do

  header 'Accept', Mime[:html].to_s
  include_context :accept_encoding_header

  let!(:promotion) { create(:promotion_with_item_quantity_flat_rate_discount_on_order_total, vendors: [create(:vendor)]) }
  let!(:promotion_id) { promotion.id }

  get '/admin/promotions/:promotion_id' do

    context 'Successfull promotion display' do
      example_request 'Successfull promotion display' do
        expect(status).to eq(200)
        expect(response_headers['Content-Type']).to match("#{Mime[:html].to_s}; charset=utf-8")
        expect(Promotion.count).to eq(1)
      end
    end
  end

end