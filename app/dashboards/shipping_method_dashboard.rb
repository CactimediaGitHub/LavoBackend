require "administrate/base_dashboard"
require 'enum_field'

class ShippingMethodDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number.with_options(searchable: true),
    # shipping_method: Field::EnumField.with_options(searchable: true, collection: ShippingMethod.shipping_methods, filterable: true, filterable_options: ShippingMethod.shipping_methods.keys.map(&:humanize)),
    shipping_method_name: Field::BelongsTo,
    vendor: Field::BelongsTo,
    shipping_charge_percent: Field::Number.with_options(decimals: 2),
    delivery_period: Field::Number,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :vendor,
    :shipping_method_name,
    :shipping_charge_percent,
    :delivery_period,
    :id,
    :created_at,
    :updated_at
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :vendor,
    :shipping_method_name,
    :shipping_charge_percent,
    :delivery_period,
    :id,
    :created_at,
    :updated_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :vendor,
    :shipping_method_name,
    :shipping_charge_percent,
    :delivery_period
  ].freeze

  # Overwrite this method to customize how shipping methods are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(shipping_method)
    shipping_method.shipping_method_name.name
  end
end
