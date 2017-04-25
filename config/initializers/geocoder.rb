Geocoder.configure(
  lookup: :google,
  api_key: ENV['GOOGLE_GEOCODE_ID'],
  timeout: 60,
  # logger: ActiveSupport::TaggedLogging.new(Logger.new(STDOUT))
)