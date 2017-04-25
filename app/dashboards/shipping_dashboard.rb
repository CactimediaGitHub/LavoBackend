require "administrate/base_dashboard"

class ShippingDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number.with_options(searchable: true),
    shipping_method: Field::BelongsTo,
    order: Field::BelongsTo,
    address: Field::HasOne,
    # state: Field::String,
    pick_up: Field::String.with_options(searchable: false),
    drop_off: Field::String.with_options(searchable: false),
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :order,
    :pick_up,
    :drop_off,
    :shipping_method,
    :id,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :shipping_method,
    :order,
    :address,
    :id,
    # :state,
    :pick_up,
    :drop_off,
    :created_at,
    :updated_at,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :shipping_method,
    :order,
    :address,
    # :state,
    :pick_up,
    :drop_off,
  ].freeze

  # Overwrite this method to customize how shippings are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(shipping)
  #   "Shipping ##{shipping.id}"
  # end
end
