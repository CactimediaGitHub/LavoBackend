ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase

  setup { host! ENV['RACK_TEST_HOST']}

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def json(body)
    JSON.parse(body, symbolize_names: true)
  end

  def auth_header(fixture)
    token = fixture.http_token.key
    {'Authorization' => "Token token=#{token}"}
  end

  def json_headers
    { 'Accept' => Mime[:json], 'Content-type' => Mime[:json].to_s }
  end

  def uploaded_file(path, content_type="image/png")
    path = Rails.root.join('test/fixtures/files', path)
    Rack::Test::UploadedFile.new(path, content_type)
  end

end
