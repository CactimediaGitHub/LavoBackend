# require Rails.root.join('config/initializers/activemerchant_extensions')

class TokenizeCardJob < ApplicationJob
  queue_as :critical

  def perform(args)
    API::V1::PaymentGateway::CreateCard.new(args).store
  end
end
