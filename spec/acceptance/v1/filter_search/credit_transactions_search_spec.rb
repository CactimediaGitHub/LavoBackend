# require 'acceptance_helper'
#
# resource "filter_search/credits_transactions/customer", document: :v1 do
#
#   include_context :accept_encoding_header
#   include_context :version_header
#   header 'Authorization', :token
#   header 'Accept', Mime[:html].to_s
#
#   let(:customer0) { create(:signed_in_customer) }
#   let(:customer1) { create(:signed_in_customer) }
#   let(:customer) { create(:signed_in_customer) }
#   let(:token) { "Token token=#{customer.http_token.key}" }
#
#   parameter :search, "Filtered search. I.e. f[customer]=1,2", required: true
#
#   get '/admin/credit_transactions' do
#
#     context 'Successfull search' do
#       let!(:ct1) { create(:credit_transaction, amount: 1111, transaction_type: :purchased, customer: customer0) }
#       let!(:ct2) { create(:credit_transaction, amount: 1110, transaction_type: :paid, customer: customer) }
#       let!(:ct3) { create(:credit_transaction, amount: 2,    transaction_type: :manual_addition, note: 'For luck!', customer: customer1) }
#       let!(:ct4) { create(:credit_transaction, amount: 1,    transaction_type: :manual_withdrawal, customer: customer) }
#       let!(:ct5) { create(:credit_transaction, amount: 1,    transaction_type: :refunded, customer: customer) }
#
#       let(:search) { "f[customer]=#{customer1.id},#{customer0.id}" }
#
#       example_request "Successfull lookup" do
#         expect(status).to eq(200)
#         expect(response_headers['Content-Type']).to match("#{Mime[:html].to_s}; charset=utf-8")
#         expect(response_body).to match('Purchased')
#         expect(response_body).to match('Manual addition')
#         expect(response_body).not_to match('Paid')
#         expect(response_body).not_to match('Manual withdrawal')
#         expect(response_body).not_to match('Refunded')
#       end
#     end
#
#     context "Respond with all resources if parameter is missing" do
#       let(:search) { '' }
#
#       example_request "Respond with all resources if parameter is missing" do
#         expect(status).to eq(200)
#       end
#     end
#
#   end
#
# end