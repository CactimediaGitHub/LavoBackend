require 'webmock/rspec'
require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = Rails.root.join("spec/fixtures/vcr_cassettes")
  c.hook_into :webmock # or :fakeweb
  c.ignore_hosts 'maps.googleapis.com'
  c.ignore_localhost = true
  c.debug_logger = File.open(Rails.root.join('log/vcr.log'), 'w')
end

module SpecHelpers
  module VcrDoRequest
    def self.[](cassette_name)
      Module.new.tap do |included_module|
        included_module.send :define_method, :do_request do |*args|
          VCR.use_cassette(cassette_name, record: :new_episodes) { super(*args) }
        end
      end
    end
  end
end
