require 'test_helper'

class VendorTest < ActionDispatch::IntegrationTest

    test "should be created, happy path" do
      post '/vendors',
        params: {
          data: {
            attributes: {
              email: 'syber@monkey.com',
              password: '123456',
              password_confirmation: '123456'
            }
          }
        }.to_json,
        headers: json_headers
      assert_response 201
      assert_equal Mime[:json].to_s, response.content_type
      assert_equal 'syber@monkey.com', Vendor.last.email
      assert_not_nil Vendor.last.password_digest
    end

end

