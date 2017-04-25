# Transform JSON request param keys from JSON-conventional dash-case to
# Rails-conventional snake_case:
ActionDispatch::Request.parameter_parsers[:json] = -> (raw_post) {
  # Modified from action_dispatch/http/parameters.rb
  data = ActiveSupport::JSON.decode(raw_post)
  data = data.is_a?(Hash) ? data : {:_json => data}

  # Transform dash-case param keys to snake_case:
  data.deep_transform_keys!(&:underscore)
}