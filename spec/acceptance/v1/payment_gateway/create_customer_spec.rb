# require 'acceptance_helper'
#
# resource "payment_gateway/customers", document: :v1 do
#
#   include_context :content_headers
#   header 'Authorization', :token
#
#   parameter :type, 'payment-gateway-customers', scope: :data, required: true
#   with_options scope: [:data, :attributes], required: true do |o|
#     o.parameter :email, 'Customer email'
#     o.parameter :name, 'Customer full name'
#     o.parameter :card, 'Customer credit card hash'
#   end
#
#   with_options(scope: [:data, :attributes, :card], required: true) do |o|
#     o.parameter :number, "Credit card number ('4242424242424242')"
#     o.parameter :month, "Credit card expiration month ('9')"
#     o.parameter :year, "Credit card expiration year ('2017')"
#     o.parameter :first_name, "Cardholder first name ('Steve')"
#     o.parameter :last_name, "Cardholder last name ('Smith')"
#     o.parameter :verification_value, "CVV verification code ('424')"
#   end
#
#   let(:customer) { create(:signed_in_customer) }
#   let(:token) { "Token token=#{customer.http_token.key}" }
#   let(:email) { customer.email }
#   let(:name) { customer.name }
#   let(:type) { 'payment-gateway-customers' }
#   let(:card) {{
#     :first_name         => 'Matt',
#     :last_name          => 'Quigley',
#     :month              => '6',
#     :year               => '2018',
#     :number             => '4242424242424242',
#     :verification_value => '424'
#   }}
#
#   post "/payment_gateway/customers" do
#     include SpecHelpers::VcrDoRequest[:payment_gateway_create_customer]
#
#     context 'Context:' do
#       example_request "Successfull customer creation" do
#         expect(status).to eq(201)
#         expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
#       end
#     end
#
#   end
#
# end
