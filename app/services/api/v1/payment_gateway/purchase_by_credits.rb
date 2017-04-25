require 'active_merchant/billing/rails'

class API::V1::PaymentGateway::PurchaseByCredits
  include ActiveModel::Model
  include ActiveModel::Serialization

  attr_accessor :credits_amount, :order_id, :credit_transaction, :payment
  attr_writer :customer

  alias_attribute :id, :order_id

  validates :credits_amount, :order_id, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :order, :customer, presence: true
  validate :sufficient_credits

  # TODO: do not require credits_amount as param, compute needed credits amount here
  def initialize(args={})
    super
    @order = Order.find_by(id: order_id)
    @customer = @order.customer
  end

  def perform
    self.credit_transaction = CreditTransaction.new do |t|
      t.amount = order.total
      t.transaction_type = :paid
      t.customer = customer
      t.note = "Paid for order ##{order.id}"
    end

    self.payment = Payment.new do |p|
      p.order = order
      p.customer = customer
      p.vendor = order.vendor
      p.order_total = order.total
      p.credits_amount = credits_amount
      p.paid_amount = 0
      p.payment_method = ::API::V1::Support::PaymentMethodCaclulator.calculate(p)
    end

    ActiveRecord::Base.transaction do
      credit_transaction.save!
      payment.save!
      order.transition_to_pending
    end
  end

  private
  attr_reader :customer, :order

  def sufficient_credits
    if customer.credits_amount < order.total
      errors.add(:base, :insufficient_credits)
    end
  end
end
