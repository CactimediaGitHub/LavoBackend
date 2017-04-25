require 'acceptance_helper'

resource "payment_gateway/payments", document: :v1 do

  include_context :no_content_headers
  header 'Authorization', :token

  let(:customer) { create(:signed_in_customer) }
  let(:token) { "Token token=#{customer.http_token.key}" }

  let!(:order) { create(:order, customer: customer)}
  let!(:card) { create(:card, customer: customer)}
  let!(:payment) { create(:payment, customer: customer,
                                      vendor: order.vendor,
                                        card: card,
                                        uuid: '6c0b841d4f3d4a4bbf78ec14fd70f7a1',
                            confirmation_url: 'https://testfort.payfort.com/secure3dsSimulator?FORTSESSIONID=19iqvoj4c2srt3vmrhrh7qc5g5&paymentId=5740559166725965820&DOID=C70BAA4D83511CCADAEC071226C925FB&o=pt&action=retry')}

  let(:id) { payment.uuid }

  get '/payments/:id' do
    context 'Successfull payment 3ds_url (confirmation_url) lookup' do


      example_request 'Successfull payment 3ds_url (confirmation_url) lookup' do
        expect(status).to eq(200)
        ap json(response_body)
        expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
        # expect(json(response_body)[:data][:attributes][:'3ds_url']).to eq(payment.3ds_url)
      end
    end
  end
end