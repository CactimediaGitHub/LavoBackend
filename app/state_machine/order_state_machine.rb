require 'support/save_notification'
class OrderStateMachine
  include Statesman::Machine
  extend API::Concerns::MailerUtils

  NEW_STATES = %i(pending updating approving).freeze
  ACTIVE_STATES = %i(processing).freeze
  HISTORY_STATES = %i(cancelled refunded completed).freeze

  state :unpersisted, initial: true
  state :unpaid
  state :pending
  state :processing
  state :cancelled
  state :refunded
  state :completed

  # openbasket
  state :updating # vendor updates the order
  state :approving # customer approve the order

  transition from: :unpersisted,  to: :unpaid
  transition from: :unpaid,       to: :pending
  transition from: :pending,      to: [:processing, :cancelled, :updating]
  transition from: :updating,     to: [:approving, :cancelled]
  transition from: :approving,    to: [:processing, :cancelled]
  transition from: :cancelled,    to: :refunded
  transition from: :processing,   to: :completed

  after_transition do |model, transition|
    model.state = transition.to_state
    model.save!
  end

  before_transition(from: :cancelled, to: :refunded) do |order, transition|
    order.
      customer.
      credit_transactions.
      create!(amount: order.total,
              transaction_type: :refunded,
              note: "Order #{order.id}") unless order.paid_by_cash?
  end

  with_options(after_commit: true) do |o|
    o.after_transition(from: :unpaid, to: :pending) do |order, transition|
      notifications_to(order, :vendor)
    end

    o.after_transition(from: :pending, to: :processing) do |order, transition|
      notifications_to(order, :customer)
    end

    o.after_transition(from: :pending, to: :cancelled) do |order, transition|
      notifications_to(order, :vendor, :customer)
      order.state_machine.transition_to(:refunded) if order.needs_refund?
    end

    o.after_transition(from: :cancelled, to: :refunded) do |order, transition|
      notifications_to(order, :customer)
    end

    o.after_transition(from: :processing, to: :completed) do |order, transition|
      order.vendor.update_balance
      notifications_to(order, :customer)
    end

    # openbasket
    o.after_transition(from: :pending, to: :updating) do |order, transition|
      notifications_to(order, :vendor)
    end

    o.after_transition(from: :updating, to: :approving) do |order, transition|
      notifications_to(order, :customer)
    end

    o.after_transition(from: :updating, to: :cancelled) do |order, transition|
      notifications_to(order, :customer)
    end

    o.after_transition(from: :approving, to: :processing) do |order, transition|
      notifications_to(order, :vendor)
    end

    o.after_transition(from: :approving, to: :cancelled) do |order, transition|
      notifications_to(order, :vendor)
    end
  end

  after_transition(from: :approving, to: :processing) do |order, transition|
    order.update_total
  end

  private

  # FIXME: use object for notifications
  def self.notifications_to(order, *recipients)
    notification(order, recipients)
    push_notification(order, recipients)
    send_mail(:lavo_order_state_changed, order, recipients.map(&:to_s))
  end

  def self.push_notification(order, recipients)
    notifiable = recipients.map { |r| order.send(r) }

    Rails.logger.tagged("Push notification for order ##{order}") do
      Rails.logger.info(order.inspect)
      Rails.logger.info('--------------')
      Rails.logger.info(recipients.inspect)
      Rails.logger.info('--------------')
      Rails.logger.info(notifiable.inspect)
      Rails.logger.info('--------------')
      Rails.logger.info(NotificationRegistration.exists?(notifiable: notifiable).inspect)
    end

    return unless NotificationRegistration.exists?(notifiable: notifiable)

    args = { order_id: order.id,
             notify: recipients.map(&:to_s) }
    OrderStatusChangeNotificationJob.perform_later(args)
  end

  def self.notification(order, recipients)
    message = "Order ##{order.id}: state changed to '#{order.state}'"

    arg_hash = {message: message, order: order, notify: recipients}
      Support::SaveNotification.new(arg_hash).perform
  end

  def self.display_states
    states - ['unpersisted']
  end
end
