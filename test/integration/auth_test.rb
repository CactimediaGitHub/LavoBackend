require 'test_helper'

class AuthTest < ActionDispatch::IntegrationTest
  setup { @customer_token = customers(:one).http_token.key }

  test "authenticated via valid http-token in header" do
    get "/customers/#{customers(:one).id}",
      headers: {'Authorization' => "Token token=#{@customer_token}"},
      params: {data: {type: :customers, id: customers(:one).id}}
    assert_response 200
    assert_equal Mime[:json].to_s, response.content_type
  end

  test "unauthorized with invalid token" do
    get "/customers/#{customers(:one).id}", headers: {'Authorization' => "Token token=#{@customer_token} fake"}
    assert_response 401
    assert_equal Mime[:json].to_s, response.content_type
  end

  # FIXME: Better authorization needed
  # test "unauthorized if tried vendor routes with customer token" do
  #   get "/vendors", headers: {'Authorization' => "Token token=#{@customer_token}"}
  #   assert_response 401
  #   assert_equal Mime[:json].to_s, response.content_type
  # end

  test "unauthorized with blank token" do
    get "/customers", headers: {'Authorization' => "Token token="}
    assert_response 401
    assert_equal Mime[:json].to_s, response.content_type
  end

  test "unauthorized withouth Authorization header" do
    get "/customers"
    assert_response 401
    assert_equal Mime[:json].to_s, response.content_type
  end

end
