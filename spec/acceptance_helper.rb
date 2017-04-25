require 'rails_helper'
require 'rspec_api_documentation'
require 'rspec_api_documentation/dsl'

# Point rack test to subdomain, hack
Rack::Test::DEFAULT_HOST = ENV['RACK_TEST_HOST']

Dir[Rails.root.join("spec/acceptance/shared/**/*.rb")].sort.each { |f| require f }

RspecApiDocumentation.configure do |config|
  config.format = [:json, :combined_text, :html]
  config.curl_host = ENV['CURL_HOST']
  config.api_name = "Lavo Laundry"

  # TODO: refactor docs_dir
  config.docs_dir = Rails.public_path.join("docs", "api", "all")

  config.define_group :v1 do |c|
    c.filter = :v1
    c.docs_dir = Rails.public_path.join("docs", "api", "v1")
    c.api_name = "API V1"
  end

  config.define_group :v2 do |c|
    c.filter = :v2
    c.docs_dir = Rails.public_path.join("docs", "api", "v2")
    c.api_name = "API V2"
  end
end