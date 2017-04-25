require 'capybara/rails'
require 'capybara/rspec'

Capybara.configure do |config|
  config.run_server   = true
  config.server_port  = 3001
  config.app_host     = 'http://127.0.0.1:3001'
  config.automatic_label_click = true
  config.enable_aria_label = true
  config.default_max_wait_time = 5
  config.register_driver(:selenium) do |app|
    Capybara::Selenium::Driver.new(app, :browser => :chrome)
  end
end