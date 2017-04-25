class API::V1::Pushes::CreateNotification
  include ActiveModel::Model

  attr_accessor :tokens, :message, :title

  def initialize(args={})
    @gateway = FCM.new(ENV['FIREBASE_CLOUD_MESSAGING_API_KEY'])
    @collapse_key = Rails.app_class.to_s.split('::').first&.underscore
    super
  end

  validates :message, :tokens, :title, presence: true

  def deliver
    Rails.logger.tagged("API::V1::Pushes::CreateNotification sidekiq job") do
      Rails.logger.info("Gateway: #{gateway.inspect}")
      Rails.logger.info("Collapse key: #{collapse_key.inspect}")
      Rails.logger.info("valid? #{valid?.inspect}")
      Rails.logger.info("valid? #{self.errors.full_messages.join(', ')}")
      Rails.logger.info("Message: #{message.inspect}")
      Rails.logger.info("Tokens: #{tokens.inspect}")
    end

    return { response: self.errors.full_messages.join(', '), code: 422 } unless valid?
    options =
      { notification: { title: title, body: message },
        collapse_key: collapse_key,
            priority: 'high' }

    Rails.logger.tagged("API::V1::Pushes::CreateNotification sidekiq job") do
      Rails.logger.info("Options: #{options.inspect}")
    end

    self.response = gateway.send(tokens, options)
  end

  private

  attr_reader :gateway, :collapse_key
  attr_accessor :response
end
