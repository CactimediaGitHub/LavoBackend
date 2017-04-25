require 'acceptance_helper'

resource "social_signin", document: :v1 do
  include_context :content_headers
  header 'Authorization', :token

  post '/social_signin' do
    include SpecHelpers::VcrDoRequest[:social_signin]

    context 'Non-existing user' do
      let(:token) { "Token token=EAAQGxZB8b7RwBACUij06ULP3skWDmZC9ZA52iz5ldk1fRsFIZBhqMTbueACr9w0xQ5wztX7EAdAXO33bEcOZCFwdeHiD0nxLOpw61SpxBUxXGuj4dJr6XEbpJjkXSvPcvXKqckOicHdUgpB9gio4NvRFsxQZC7jQOyxa7w1OyNZCB2AYXb1l4gA" }

      example_request "Non-existing user authentication by valid FB access token" do
        expect(headers['Authorization']).to eq(token)
        expect(status).to eq(200)
        expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")

        rb = JSON.parse(response_body)
        expect(rb["included"][0]["attributes"]["key"]).to be_present
        expect(rb["data"]["attributes"]["email"]).to match(/@facebook/)
        expect(rb["data"]["attributes"]["avatar"]).to be_present
        expect(rb["data"]["attributes"]["activated"]).to be true
      end
    end

    context 'Returning user' do
      let!(:user) { create(:customer, email: "10201586668465514@facebook.com", http_token: HttpToken.new(key: :blah)) }
      let(:token) { "Token token=EAAQGxZB8b7RwBACUij06ULP3skWDmZC9ZA52iz5ldk1fRsFIZBhqMTbueACr9w0xQ5wztX7EAdAXO33bEcOZCFwdeHiD0nxLOpw61SpxBUxXGuj4dJr6XEbpJjkXSvPcvXKqckOicHdUgpB9gio4NvRFsxQZC7jQOyxa7w1OyNZCB2AYXb1l4gA" }

      example_request "Returning user authentication by new valid FB access token" do
        expect(status).to eq(200)
        rb = JSON.parse(response_body)
        expect(rb["included"][0]["attributes"]["key"]).to be_present
      end
    end

    context 'Invalid or expired FB access token' do
      let(:token) { "Token token=fake+EAAQGxZB8b7RwBACUij06ULP3skWDmZC9ZA52iz5ldk1fRsFIZBhqMTbueACr9w0xQ5wztX7EAdAXO33bEcOZCFwdeHiD0nxLOpw61SpxBUxXGuj4dJr6XEbpJjkXSvPcvXKqckOicHdUgpB9gio4NvRFsxQZC7jQOyxa7w1OyNZCB2AYXb1l4gA" }

      example_request "Respond with error if FB access token expired" do
        expect(status).to eq(401)

        rb = JSON.parse(response_body)
        expect(rb["errors"][0]["detail"]).to match("is invalid or expired")
      end
    end

  end

end