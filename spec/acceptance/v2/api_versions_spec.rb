resource "api_version_tests", document: :v2 do

  include_context :content_headers
  header 'X-API-Version', "api.v2"

  get "/api_version_tests" do
    example_request "API versions header usage demo", document: :v2 do
      expect(status).to eq(200)
      expect(response_body).to match('v2')
      expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
    end
  end
end