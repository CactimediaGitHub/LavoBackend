# require 'acceptance_helper'
#
# resource "filter_search/shipping/order shipping_address", document: :v1 do
#
#   header 'Accept', Mime[:html].to_s
#   include_context :accept_encoding_header
#
#   let(:customer0) { create(:signed_in_customer) }
#   let(:customer1) { create(:signed_in_customer) }
#   let(:customer) { create(:signed_in_customer) }
#
#   let(:vendor0) { create(:vendor) }
#   let(:vendor1) { create(:vendor) }
#   let(:vendor) { create(:vendor) }
#
#   let!(:order0) { create(:paid_order, customer: customer0, vendor: vendor0) }
#   let!(:order1) { create(:paid_order, customer: customer1, vendor: vendor1) }
#   let!(:order) { create(:paid_order, customer: customer, vendor: vendor) }
#
#   parameter :search, "Filtered search. I.e. f[order]=1,2&f[shipping_address]=1,2", required: true
#
#   get '/admin/shippings' do
#
#     context 'Successfull search' do
#       let(:search) { "f[order]=#{order0.id},#{order1.id}" }
#
#       example_request "Successfull lookup" do
#         expect(status).to eq(200)
#         expect(response_headers['Content-Type']).to match("#{Mime[:html].to_s}; charset=utf-8")
#       end
#     end
#   end
#
# end