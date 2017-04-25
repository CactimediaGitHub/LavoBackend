RSpec.shared_context :version_header do
  header 'X-API-Version', "api.v1"
end

RSpec.shared_context :accept_header do
  header 'Accept', Mime[:json].to_s
end

RSpec.shared_context :accept_encoding_header do
  header 'Accept-Encoding', 'gzip'
end

RSpec.shared_context :content_type_header do
  header 'Content-Type', "#{Mime[:json]}; charset=utf-8"
end

RSpec.shared_context :params_to_json do
  let(:raw_post) { params.to_json }
end

RSpec.shared_context :no_content_headers do
  include_context :accept_header
  include_context :accept_encoding_header
  include_context :version_header
  include_context :params_to_json
end

RSpec.shared_context :content_headers do
  include_context :content_type_header
  include_context :no_content_headers
end
