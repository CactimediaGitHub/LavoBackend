require "administrate/base_dashboard"

class Promotion
  module Actions
    class CreateItemAdjustmentDashboard < Administrate::BaseDashboard
      ATTRIBUTE_TYPES = {
        promotion: Field::BelongsTo,
        calculator: Field::HasOne,
        calculator_type: Field::SelectBasic.with_options(choices: Rails.configuration.x.calculators.map {|c| [c.description, c.new.type] }),
        calculator_amount: Field::Number,
        adjustments: Field::HasMany,
        id: Field::Number.with_options(searchable: true),
        type: Field::String,
        deleted_at: Field::DateTime,
      }.freeze

      COLLECTION_ATTRIBUTES = %i[
        promotion
        id
      ].freeze

      SHOW_PAGE_ATTRIBUTES = %i[
        promotion
        id
      ].freeze

      FORM_ATTRIBUTES = %i[
        promotion
        calculator_type
        calculator_amount
      ].freeze
    end
  end
end
