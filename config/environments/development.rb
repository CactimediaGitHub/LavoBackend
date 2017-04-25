Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable/disable caching. By default caching is disabled.
  if Rails.root.join('tmp/caching-dev.txt').exist?
    config.action_controller.perform_caching = true

    config.action_mailer.perform_caching = false

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => 'public, max-age=172800'
    }
  else
    config.action_controller.perform_caching = false

    config.action_mailer.perform_caching = false

    config.cache_store = :null_store
  end

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load


  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker

  # Carrierwave use this to render true url
  config.debug_exception_response_format = :default

  # config.active_job.queue_adapter     = :sidekiq
  config.active_job.queue_adapter     = :async
  config.active_job.logger = ActiveSupport::TaggedLogging.new(Logger.new(Rails.root.join('log/active_job.log')))

  config.asset_host = ENV['ASSET_HOST']

  config.assets.enabled = true
  config.assets.raise_runtime_errors = true
  config.assets.debug = true
  config.assets.digest = false

  config.action_mailer.perform_deliveries = true
  config.action_mailer.show_previews = false
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.perform_caching = false
  config.action_mailer.default_url_options = { host: ENV['BASE_API_HOST'] }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address:              'smtp.gmail.com',
    port:                 587,
    domain:               'litslink.com',
    user_name:            'no_reply@litslink.com',
    password:             'sPs12345',
    authentication:       'plain',
    enable_starttls_auto: true  }
end
