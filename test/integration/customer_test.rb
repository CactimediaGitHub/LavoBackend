# NOTE: take a look when updatin profile

# require 'test_helper'
#
# class CustomerTest < ActionDispatch::IntegrationTest
#
#   describe "creation, happy path" do
#     before do
#       post '/customers',
#         params: {
#           customer: {
#             email: 'syber@monkey.com',
#             password: '123456',
#             password_confirmation: '123456',
#             avatar: uploaded_file('png.png'),
#             address_attributes: {city: 'Kyiv', country: 'UA'} }
#         },
#         headers: { 'Accept' => Mime[:json], 'Content-type' => Mime[:json].to_s }
#
#         @user = Customer.last
#     end
#
#     it { assert_response 201 }
#     it { assert_equal Mime[:json].to_s, response.content_type }
#     it { assert_equal 'syber@monkey.com', @user.email }
#     it { assert_not_nil @user.password_digest }
#     it { assert_not_nil @user.activation_digest }
#     it { assert_not_nil @user.address }
#     it { assert_match /Kyiv/, response.body }
#     it { assert_match /uploads\/customer\/avatar/, response.body }
#   end
#
# end
