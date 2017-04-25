require 'acceptance_helper'

resource "admin/promotions/create_promotion", document: :v1 do

  header 'Accept', Mime[:html].to_s
  include_context :accept_encoding_header

  parameter :promotion, 'Typical promotion structure'

  with_options scope: :promotion do |o|
    o.parameter :name, 'Promotion name', required: true
    o.parameter :description, 'Promotion description', required: true
    o.parameter :starts_at, 'Promotion start date'
    o.parameter :expires_at, 'Promotion end date'
    o.parameter :match_policy, 'Match policy'
  end

  let(:name) { 'My test promo' }
  let(:description) { 'My test promo description' }
  let(:starts_at) { Time.now }
  let(:expires_at) { Time.now + 1.day }
  let(:match_policy) { 'any' }

  post '/admin/promotions' do

    context 'Successfull promotion creation' do
      example_request 'Successfull promotion creation' do
        expect(status).to eq(302)
        expect(response_headers['Content-Type']).to match("#{Mime[:html].to_s}; charset=utf-8")
        expect(Promotion.count).to eq(1)
      end
    end
  end

end