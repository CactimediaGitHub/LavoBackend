require 'active_support/concern'
require 'active_merchant/billing/credit_card'

module ActivemerchantCreditCardExtention
  extend ActiveSupport::Concern

  included do
    include ActiveModel::Serializers::JSON
    attr_reader :attributes, :errors
    attr_accessor :nick
  end

  class_methods do
    def human_attribute_name(attr, options = {})
      attr
    end
  end

  def initialize(attributes = {})
    @attributes = attributes && attributes.symbolize_keys
    @errors = ActiveModel::Errors.new(self)
    super
  end

  def id
    attributes.fetch(:id) { self.class.name.downcase }
  end

  def read_attribute_for_validation(attr)
    send(attr)
  end

end

module ActivemerchantResponseExtention
  extend ActiveSupport::Concern

  included do
    include ActiveModel::Serializers::JSON
    attr_reader :attributes
  end

  def id
    self.class.name.downcase
  end

  def attributes
    @attributes ||= [:params, :message, :test, :authorization, :avs_result, :cvv_result, :error_code, :emv_authorization]
  end
end

ActiveMerchant::Billing::CreditCard.send(:include, ActivemerchantCreditCardExtention)
ActiveMerchant::Billing::Response.send(:include, ActivemerchantResponseExtention)