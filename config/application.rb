require File.expand_path('../boot', __FILE__)

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'action_cable/engine'
require 'rails/test_unit/railtie'
require 'active_support/railtie'
require 'sprockets/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module LavoLaundry
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    autoload_paths = [
      Rails.root.join('lib'),
      Rails.root.join('app/support/administrate'),
      Rails.root.join('app/support/administrate/field'),
    ].map(&:to_s)

    autoload_paths.each do |path|
      config.autoload_paths << path
    end

    config.eager_load_paths << Rails.root.join('lib').to_s

    # http://webuild.envato.com/blog/how-to-organise-i18n-without-losing-your-translation-not-found/
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]

    #NOTE: for administrate gem
    config.middleware.use ActionDispatch::Flash
    config.middleware.use Rack::MethodOverride
    config.middleware.use ActionDispatch::Cookies
    config.middleware.use ActionDispatch::Session::CookieStore
    # As conveyed by Ganesh adding time_zone to Asia/Dubai
    config.time_zone = 'Asia/Dubai'

    # config.generators do |g|
    #   g.test_framework :rspec, fixture: false,
    #   g.fixture_replacement :factory_girl, dir: 'spec/factories'
    #   g.integration_tool :rspec
    # end
  end
end
