class PurchaseJob < ApplicationJob
  queue_as :critical

  def perform(args)
    API::V1::PaymentGateway::Purchase.new(args).perform
  end
end
