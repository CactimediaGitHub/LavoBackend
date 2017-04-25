require "administrate/base_dashboard"

class Promotion
  module Rules
    class OrderItemDiscountDashboard < Administrate::BaseDashboard
      ATTRIBUTE_TYPES = {
        promotion: Field::BelongsTo,
        id: Field::Number.with_options(searchable: true),
        type: Field::String,
        created_at: Field::DateTime,
        updated_at: Field::DateTime,
        preferences: Field::Text,
        preferred_service_id: Field::SelectBasic.with_options(choices: Service.pluck(:name, :id)),
        preferred_item_id: Field::SelectBasic.with_options(choices: Item.pluck(:name, :id)),
        preferred_item_type_id: Field::SelectBasic.with_options(choices: ItemType.pluck(:name, :id)),
      }.freeze

      COLLECTION_ATTRIBUTES = %i[
        id
        promotion
        preferences
        created_at
      ].freeze

      SHOW_PAGE_ATTRIBUTES = %i[
        id
        promotion
        preferences
        created_at
      ].freeze

      FORM_ATTRIBUTES = %i[
        promotion
        preferred_service_id
        preferred_item_id
        preferred_item_type_id
      ].freeze
    end
  end
end
