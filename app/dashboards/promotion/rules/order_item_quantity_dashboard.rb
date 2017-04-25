require "administrate/base_dashboard"

class Promotion
  module Rules
    class OrderItemQuantityDashboard < Administrate::BaseDashboard
      # ATTRIBUTE_TYPES
      # a hash that describes the type of each of the model's fields.
      #
      # Each different type represents an Administrate::Field object,
      # which determines how the attribute is displayed
      # on pages throughout the dashboard.
      ATTRIBUTE_TYPES = {
        promotion: Field::BelongsTo,
        id: Field::Number.with_options(searchable: true),
        type: Field::String,
        created_at: Field::DateTime,
        updated_at: Field::DateTime,
        preferred_order_item_quantity: Field::Number,
        preferences: Field::Text,
        basic_info: Field::String,
      }.freeze

      # COLLECTION_ATTRIBUTES
      # an array of attributes that will be displayed on the model's index page.
      #
      # By default, it's limited to four items to reduce clutter on index pages.
      # Feel free to add, remove, or rearrange items.
      COLLECTION_ATTRIBUTES = %i[
        id
        promotion
        basic_info
        created_at
      ].freeze

      # SHOW_PAGE_ATTRIBUTES
      # an array of attributes that will be displayed on the model's show page.
      SHOW_PAGE_ATTRIBUTES = [
        :id,
        :promotion,
        :basic_info,
        :created_at,
        :type,
        :updated_at,
      ].freeze

      # FORM_ATTRIBUTES
      # an array of attributes that will be displayed
      # on the model's form (`new` and `edit`) pages.
      FORM_ATTRIBUTES = %i[
        promotion
        preferred_order_item_quantity
      ].freeze

      # Overwrite this method to customize how order item quantities are displayed
      # across all pages of the admin dashboard.
      #
      # def display_resource(order_item_quantity)
      #   "Promotion::Rules::OrderItemQuantity ##{order_item_quantity.id}"
      # end
    end
  end
end
