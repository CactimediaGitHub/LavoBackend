require "administrate/base_dashboard"

class PayoutDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    vendor: Field::BelongsTo,
    id: Field::Number,
    amount: Field::AmountFormat,
    note: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    payment_status: Field::EnumField.with_options(searchable: true,
                                                  collection: Payout.payment_statuses,
                                                  filterable: true,
                                                  filterable_options: Payout.payment_statuses.keys.map(&:humanize))

  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :vendor,
    :payment_status,
    :id,
    :amount,
    :note,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :vendor,
    :id,
    :amount,
    :note,
    :created_at,
    :updated_at,
    :payment_status,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :vendor,
    :amount,
    :note,
    :payment_status,
  ].freeze

  # Overwrite this method to customize how payouts are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(payout)
  #   "Payout ##{payout.id}"
  # end
end
