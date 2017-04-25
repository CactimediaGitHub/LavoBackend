require "administrate/base_dashboard"

class PaymentDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    order: Field::BelongsTo,
    card: Field::BelongsTo,
    customer: Field::BelongsTo,
    vendor: Field::BelongsTo,
    id: Field::Number,
    paid_amount: Field::AmountFormat,
    credits_amount: Field::Number,
    order_total: Field::AmountFormat,
    status: Field::String,
    response_code: Field::String,
    response_message: Field::String,
    fort_id: Field::String,
    response: Field::String.with_options(searchable: false),
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    payment_method: Field::EnumField.with_options(filterable: true, filterable_options: Payment.payment_methods.keys.map(&:humanize)),

  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i(
    vendor
    customer
    card
    order
    payment_method
    order_total
    paid_amount
    credits_amount
    response_message
    fort_id
    created_at
    status
    response_code
  ).freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :order,
    :card,
    :customer,
    :vendor,
    :id,
    :paid_amount,
    :credits_amount,
    :order_total,
    :status,
    :response_code,
    :response_message,
    :fort_id,
    :response,
    :created_at,
    :updated_at,
    :payment_method,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :order,
    :card,
    :customer,
    :vendor,
    :paid_amount,
    :credits_amount,
    :order_total,
    :status,
    :response_code,
    :response_message,
    :fort_id,
    :response,
    :payment_method,
  ].freeze

  # Overwrite this method to customize how payments are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(payment)
  #   "Payment ##{payment.id}"
  # end
end
