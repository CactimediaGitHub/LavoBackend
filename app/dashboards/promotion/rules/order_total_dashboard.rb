require "administrate/base_dashboard"

class Promotion
  module Rules
    class OrderTotalDashboard < Administrate::BaseDashboard
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
        preferred_operator_min: Field::SelectBasic.with_options(searchable: false, choices: Promotion::Rules::OrderTotal::OPERATORS_MIN.map{|o|[I18n.t("order_total_rule.operators.#{o}"), o]}),
        preferred_amount_min: Field::AmountFormat.with_options(searchable: false),
        preferred_operator_max: Field::SelectBasic.with_options(searchable: false, choices: Promotion::Rules::OrderTotal::OPERATORS_MAX.map{|o|[I18n.t("order_total_rule.operators.#{o}"), o]}),
        preferred_amount_max: Field::AmountFormat.with_options(searchable: false),

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
        :promotion,
        :id,
        :type,
        :basic_info,
        :created_at,
        :updated_at,
      ].freeze

      # FORM_ATTRIBUTES
      # an array of attributes that will be displayed
      # on the model's form (`new` and `edit`) pages.
      FORM_ATTRIBUTES = [
        :promotion,
        # :type,
        # :preferences,
        :preferred_operator_min,
        :preferred_amount_min,
        :preferred_operator_max,
        :preferred_amount_max,
      ].freeze

      # Overwrite this method to customize how order totals are displayed
      # across all pages of the admin dashboard.
      #
      # def display_resource(order_total)
      #   "Promotion::Rules::OrderTotal ##{order_total.id}"
      # end
    end
  end
end
