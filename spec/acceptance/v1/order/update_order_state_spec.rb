require 'acceptance_helper'

resource "order/update_order_state for vendor, customer", document: :v1 do

  include_context :content_headers
  header 'Authorization', :token

  parameter :id, 'Order id', required: true
  parameter :state, 'New order state', required: true

  let(:customer) { create(:signed_in_customer) }
  let(:vendor) { create(:signed_in_vendor) }
  let!(:order) { create(:paid_order, vendor: vendor, customer: customer) }
  let(:id) { order.id }

  let!(:notification_registration) {
    create :notification_registration,
           notify: true,
           token: 'eZs-sHGEylQ:APA91bFnxJv3qg3jrhrA0syRX1z9pSiZsyKYO2xT7SMVi_BfreYczSJgjxyPX3TTTkKSB-G5H6rx86tv6luLWEtlLnPwB6mtcpkdV846chzxGYoEEJlkN5TdkJQemfxgE5ZYjvXxx7Mm',
           notifiable: customer
  }

  let!(:notification_registration_vendor) {
    create :notification_registration,
           notify: true,
           token: 'cvmL6bQR3Bw:APA91bH58O800l3kC_Td8hXBbI0GPZzLBbtbshZcrfARImODARnOiwPRnskXKJlEHZ9aSqgBVtsLp8V3y_p8N1PlTmz6u86ok5pj3ifytfa01jIWfhLfyEkS8mZDFIq75Zzjbqmfe6nP',
           notifiable: vendor
  }

  patch "/order_states/:id" do
    include SpecHelpers::VcrDoRequest[:order_change_state]

    context 'Vendor' do
      let(:token) { "Token token=#{vendor.http_token.key}" }

      context 'updates order state to "processing"' do
        let(:state) { 'processing' }

        example_request 'Vendor update order state to "processing"' do
          expect(status).to eq(200)
          expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
          expect(json(response_body)[:data][:attributes][:state]).to match('processing')
          expect(Notification.count).to eq(2)
          expect(Notification.last.message).to eq("Order ##{order.id}: state changed to 'processing'")
          expect(Notification.last.notifiable).to eq(customer)
        end
      end

      # context 'updates order state to "completed"' do
      #   let(:state) { 'completed' }
      #
      #   before { order.state_machine.transition_to(:processing) }
      #
      #   example_request 'updates order state to "completed"' do
      #     expect(status).to eq(200)
      #     expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
      #     expect(json(response_body)[:data][:attributes][:state]).to match('completed')
      #   end
      # end

      context 'updates order state to "cancelled"' do
        let(:state) { 'cancelled' }

        example_request 'updates order state to "cancelled"' do
          expect(status).to eq(200)
          expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
          expect(json(response_body)[:data][:attributes][:state]).to match('refunded')
          expect(Notification.count).to eq(4)
          expect(Notification.second.message).to eq("Order ##{order.id}: state changed to 'cancelled'")
          expect(Notification.second.notifiable).to eq(vendor)
          expect(Notification.last.message).to eq("Order ##{order.id}: state changed to 'refunded'")
          expect(Notification.last.notifiable).to eq(customer)
        end
      end

      context 'Error when updating order state in not allowed/wrong state' do
        let(:state) { 'completed' }

        example_request 'Error when updating order state in not allowed/wrong state' do
          expect(status).to eq(422)
          expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
          expect(json(response_body)[:errors][0][:detail]).to match('is invalid')
          expect(Notification.count).to eq(1)
        end
      end
    end

    context 'Customer' do
      let(:token) { "Token token=#{customer.http_token.key}" }

      context 'updates order state to "cancelled"' do
        let(:state) { 'cancelled' }

        example_request 'updates order state to "cancelled"' do
          expect(status).to eq(200)
          expect(response_headers['Content-Type']).to match("#{Mime[:json].to_s}; charset=utf-8")
          expect(json(response_body)[:data][:attributes][:state]).to match('refunded')
          expect(Notification.count).to eq(4)
          expect(Notification.second.message).to eq("Order ##{order.id}: state changed to 'cancelled'")
          expect(Notification.second.notifiable).to eq(vendor)
          expect(Notification.last.message).to eq("Order ##{order.id}: state changed to 'refunded'")
          expect(Notification.last.notifiable).to eq(customer)
        end
      end
    end
  end
end
