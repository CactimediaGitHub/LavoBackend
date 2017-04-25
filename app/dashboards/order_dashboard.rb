require "administrate/base_dashboard"

class OrderDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    vendor: Field::BelongsTo,
    customer: Field::BelongsTo,
    shipping: Field::HasOne,
    shipping_method: Field::HasOne,
    address: Field::HasOne,
    order_items: Field::HasMany,
    inventory_items: Field::HasMany,
    payment: Field::HasOne,
    transitions: Field::HasMany.with_options(class_name: "OrderTransition"),
    id: Field::Number,
    total: Field::AmountFormat,
    promotion_amount: Field::AmountFormat,
    shipping_amount: Field::AmountFormat,
    state: Field::String.with_options(filterable: true, filterable_options: OrderStateMachine.display_states),
    openbasket: Field::Boolean.with_options(filterable: true, filterable_options: [true, false]),
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    state
    openbasket
    vendor
    customer
    created_at
    id
    shipping_method
    total
    promotion_amount
    address
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    id
    vendor
    customer
    order_items
    total
    shipping_amount
    promotion_amount
    state
    shipping_method
    shipping
    address
    payment
    created_at
    updated_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :vendor,
    :customer,
    :shipping,
    :shipping_method,
    :address,
    :order_items,
    :inventory_items,
    :total,
    :state,
  ].freeze

  # Overwrite this method to customize how orders are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(order)
  #   "Order ##{order.id}"
  # end
end
