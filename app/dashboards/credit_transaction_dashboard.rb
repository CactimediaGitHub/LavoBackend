require "administrate/base_dashboard"
require 'enum_field'

class CreditTransactionDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  # NOTE: https://github.com/thoughtbot/administrate/issues/620
  ATTRIBUTE_TYPES = {
    customer: Field::BelongsTo,
    id: Field::Number,
    amount: Field::AmountFormat.with_options(searchable: true),
    note: Field::String,
    created_at: Field::DateTime.with_options(searchable: true),
    updated_at: Field::DateTime,
    transaction_type: Field::EnumField.with_options(
                                         searchable: true,
                                         collection: CreditTransaction.transaction_types.slice('manual_addition', 'manual_withdrawal'),
                                         filterable: true,
                                         filterable_options: CreditTransaction.transaction_types.keys.map(&:humanize))
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    customer
    amount
    transaction_type
    created_at
    note
    id
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :customer,
    :id,
    :amount,
    :note,
    :created_at,
    :updated_at,
    :transaction_type,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :customer,
    :amount,
    :note,
    :transaction_type,
  ].freeze

  # Overwrite this method to customize how credit transactions are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(credit_transaction)
  #   "CreditTransaction ##{credit_transaction.id}"
  # end
end
