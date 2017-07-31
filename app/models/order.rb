class Order < ApplicationRecord
  include Statesman::Adapters::ActiveRecordQueries
  include FilterablePgSearchScope

  belongs_to :vendor
  belongs_to :customer

  has_one :shipping, inverse_of: :order
  has_one :shipping_method, through: :shipping
  has_one :address,         through: :shipping

  validate :pickup_holiday?
  validate :dropoff_holiday?

  # NOTE: payfort now allows one payment per order_id (merchant reference)
  has_one :payment

  with_options dependent: :destroy do
    has_many :adjustments, -> { order(:created_at) }, as: :adjustable
    has_many :inventory_items, through: :order_items
    has_many :order_items, inverse_of: :order
  end

  has_many :transitions, class_name: "OrderTransition", autosave: false
  has_many :all_adjustments,
         class_name: 'Adjustment',
         foreign_key: :order_id,
         dependent: :destroy,
         inverse_of: :order

  has_many :order_promotions
  has_many :promotions, through: :order_promotions, class_name: 'Promotion'
  delegate :name, to: :customer, prefix: true
  delegate :payment_method, to: :payment, prefix: false
  delegate :commission, to: :vendor, prefix: true

  # accepts_nested_attributes_for :order_items
  validates_associated :order_items

  # accepts_nested_attributes_for :shipping
  validates_associated :shipping

  validates :vendor, presence: true
  validates :customer, presence: true
  validates :shipping, presence: true

  validates :total,
            numericality: { greater_than: 0, only_integer: true },
            unless: :openbasket

  after_create :set_initial_state

  scope :openbasket, -> { where(openbasket: true) }
  scope :regularbasket, -> { where(openbasket: false) }

  pg_search_scope(:search,
    associated_against: {
      vendor: [:name],
      customer: [:email, :name, :surname, :phone],
      address: [:address1, :address2, :city, :country, :nearest_landmark],
    },
  )

  # ATTRIBUTE_TYPES = {
  #   vendor: Field::BelongsTo,
  #   customer: Field::BelongsTo,
  #   shipping: Field::HasOne,
  #   shipping_method: Field::HasOne,
  #   address: Field::HasOne,
  #   order_items: Field::HasMany,
  #   inventory_items: Field::HasMany,
  #   payment: Field::HasOne,
  #   transitions: Field::HasMany.with_options(class_name: "OrderTransition"),
  #   id: Field::Number,
  #   total: AmountFormatField,
  #   state: Field::String.with_options(filterable: true, filterable_options: OrderStateMachine.display_states),
  #   openbasket: Field::Boolean.with_options(filterable: true, filterable_options: [true, false]),
  #   created_at: Field::DateTime,
  #   updated_at: Field::DateTime,
  # }.freeze

  def state_machine
    @state_machine ||= OrderStateMachine.new(self, transition_class: OrderTransition,
                                                   association_name: :transitions)
  end

  def amount
    order_items.to_a.reduce(0.0) {|res,item| res + item.amount}
  end

  def self.transition_class
    OrderTransition
  end
  private_class_method :transition_class

  def self.transition_name
    :transitions
  end

  def self.initial_state
    :unpaid
  end
  private_class_method :initial_state

  def needs_refund?
    total > 0
  end

  def transition_to_pending
    state_machine.transition_to(:pending)
  end

  def update_total
    total =
      API::Order::CartCalculator.new(order_items: order_items.map(&:serializable_hash),
                                        shipping: shipping.serializable_hash).total
    self.update_column(:total, total)
  end

  def self.to_xlsx(collection)
    package = Axlsx::Package.new
    workbook = package.workbook
    workbook.add_worksheet(name: collection.model.to_s.downcase) do |sheet|
      sheet.add_row(['id', 'total', 'state', 'openbasket', 'vendor', 'customer',
                     'created at', 'shipping method', 'address'])
      collection.each do |object|
        sheet.add_row([object.id, object.total, object.state, object.openbasket.to_s,
                       object.vendor.name, object.customer.full_name,
                       object.created_at, object.shipping_method.shipping_method,
                       object.address.to_s])
      end
    end
    package.to_stream.read
  end

  def paid_by_cash?
    payment.cash?
  end

  # Fetches vendors transactions details
  def self.fetch_order_report(vendor_ids, start_date, end_date)
    vendor_ids = vendor_ids.compact.reject{ |vendor_id| vendor_id.strip.empty? }
    return [] if vendor_ids.blank? && start_date.blank? && end_date.blank?
    orders = Order.includes(:vendor, :payment)
      .where('orders.vendor_id IN (?)', vendor_ids).references(:orders)
    if (start_date.present? && end_date.present?)
      orders = orders
        .where('orders.created_at BETWEEN (?) AND (?)',start_date, end_date)
    end
    orders
  end

  def self.to_orders_csv(collection)
    CSV.generate(headers: true) do |csv|
      csv << ['Order date', 'Customer name', 'Order number', 
              'Order type', 'Payment type', 
              'Status', 'Total bill amount', 
              'Lavo commision on', 'Net payable amount to vendor']
      collection.each do |object|
        csv << [object.created_at.strftime('%B %d, %Y %I:%M %p'), object.customer_name,
                object.id, object.openbasket ? 'Open Basket' : 'Regular',
                object.payment.present? ? object.payment_method.try(:titleize) : '', object.state.titleize,
                "#{'%.2f' % object.total_in_aed} AED", "#{'%.2f' % object.vendor_commission} AED", "#{'%.2f' % (object.total_in_aed - object.vendor_commission)} AED"]
      end
    end
  end

  def total_in_aed
    total.present? ? total/100 : 0
  end

  def payable_amount
    if vendor.flat_rate && vendor.flat_rate != 0
      (total_in_aed - vendor.flat_rate).to_i
    elsif vendor.commission && vendor.commission != 0
      (total_in_aed * ((100 - vendor.commission.to_f)/100)).to_i
    else
      total_in_aed
    end
  end

  private

  def set_initial_state
    state_machine.transition_to!(self.class.send(:initial_state))
  end

  def pickup_holiday?
    holidays = vendor.holidays.select{|h| h.holiday_date.to_date.eql?(shipping.pick_up.first.to_date)}
    if holidays.present?
      holiday_names = holidays.map(&:name).join(', ')
      errors.add(:pickup_holiday, "Closed on occasion of #{holiday_names}")
    end
  end

  def dropoff_holiday?
    holidays = vendor.holidays.select{|h| h.holiday_date.to_date.eql?(shipping.drop_off.first.to_date)}
    if holidays.present?
      errors.add(:dropoff_holiday, "Closed on occasion of #{holiday_names}")
    end
  end

end
