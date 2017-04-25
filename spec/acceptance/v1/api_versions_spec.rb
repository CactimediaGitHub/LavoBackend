require 'acceptance_helper'

resource "api_version_tests", document: :v1 do

  include_context :content_headers
  include_context :version_header

  get "/api_version_tests" do
    example_request "API versions header usage demo" do
      expect(status).to eq(200)
      expect(response_body).to match('v1')
      expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
    end
  end
end
