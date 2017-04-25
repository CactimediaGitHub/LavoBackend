require "administrate/base_dashboard"

class InventoryItemDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    price: Field::AmountFormat.with_options(searchable: true),
    item: Field::BelongsTo,
    item_type: Field::BelongsTo,
    service: Field::BelongsTo,
    vendor: Field::BelongsTo,
    id: Field::Number,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :id,
    :vendor,
    :service,
    :item,
    :item_type,
    :price,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :vendor,
    :service,
    :item,
    :item_type,
    :price,
    :created_at,
    :updated_at,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :vendor,
    :service,
    :item,
    :item_type,
    :price,
  ].freeze

  # Overwrite this method to customize how inventory items are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(inventory_item)
    "#{inventory_item.item}, #{inventory_item.service}, #{inventory_item.vendor}"
  end
end
