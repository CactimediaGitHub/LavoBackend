require 'acceptance_helper'

resource "static pages/show", document: :v1 do
  include_context :no_content_headers

  parameter :id, 'Statick page nick. I.e. "about"', required: true

  let!(:page) { create(:page, nick: 'aBoUt') }
  let(:id) { 'abOut' }

  get "/pages/:id" do
    example_request "Successfull GET request with image gallery" do
      expect(status).to eq(200)
      ap json(response_body)
      expect(json(response_body)[:data][:id]).to eq(page.id.to_s)
    end
  end
end
