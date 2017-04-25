require "administrate/base_dashboard"

class ShippingAddressDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    shipping: Field::BelongsTo,
    order: Field::HasOne,
    vendor: Field::HasOne,
    customer: Field::HasOne,
    id: Field::Number.with_options(searchable: true),
    address1: Field::String,
    address2: Field::String,
    city: Field::String,
    country: Field::String,
    nearest_landmark: Field::String,
    human_name: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    shipping
    order
    vendor
    customer
    address1
    address2
    city
    country
    nearest_landmark
    id
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :shipping,
    :order,
    :id,
    :address1,
    :address2,
    :city,
    :country,
    :nearest_landmark,
    :human_name,
    :created_at,
    :updated_at,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :address1,
    :address2,
    :city,
    :country,
    :nearest_landmark,
    :human_name,
  ].freeze

  # Overwrite this method to customize how shipping addresses are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(shipping_address)
  #   "ShippingAddress ##{shipping_address.id}"
  # end
end
