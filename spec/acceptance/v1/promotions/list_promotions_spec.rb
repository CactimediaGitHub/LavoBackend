require 'acceptance_helper'

resource "promotions", document: :v1 do

  include_context :no_content_headers
  header 'Authorization', :token

  let(:token) { "Token token=#{create(:customer_token).key}" }

  get "/promotions" do
    let!(:promotion1) { create(:promotion_with_order_total_flat_rate_on_order_total)}
    let!(:promotion2) { create(:promotion_with_item_quantity_flat_rate_discount_on_order_total) }
    let!(:promotion3) { create(:promotion_with_item_quantity_flat_percent_discount_on_order_total) }
    let!(:promotion4) { create(:order_total_flat_percent_on_order_item_total) }
    let!(:promotion5) { create(:promotion_with_order_total_flat_percent_on_order_total, icon: uploaded_file('png.png'))}

    context 'Successfull promotions listing' do
      example_request 'Successfull promotions listing' do
        ap json(response_body)

        expect(status).to eq(200)
        expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
        expect(json(response_body)[:data].size).to eq(5)
        expect(json(response_body)[:data][0][:attributes][:icon][:url]).to match("promotion/icon")
        expect(json(response_body)[:data][0][:attributes][:"background-image-url"]).to match(" ")
      end
    end

  end

end