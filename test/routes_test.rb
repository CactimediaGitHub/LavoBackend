require 'test_helper'

class Routes < ActionDispatch::IntegrationTest

  setup { host! ENV['RACK_TEST_HOST'] }

  test 'namespace costraints' do
    assert_generates '/customers', controller: 'api/v1/customers'
  end

  test 'domain costraints' do
    assert_generates '/customers', subdomain: 'api', controller: 'api/v1/customers'
  end
end