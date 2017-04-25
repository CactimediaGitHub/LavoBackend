require "administrate/base_dashboard"
require 'carrierwave_field'
# require "nested_has_many"

class PromotionDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    # promotion_rules: Field::NestedHasMany.with_options(
    #   skip: %i(vendor_id promotion preferences updated_at created_at preferred_operator_min preferred_operator_max preferred_amount_min preferred_amount_max),
    #   class_name: 'PromotionRule'),
    #
    # promotion_actions: Field::NestedHasMany.with_options(
    #   skip: %i(promotion preferences deleted_at),
    #   class_name: 'PromotionAction'),
    promotion_rules: Field::HasMany,
    promotion_actions: Field::HasMany,

    id: Field::Number.with_options(searchable: true),
    name: Field::String.with_options(searchable: true),
    vendors: Field::HasMany,
    description: Field::String,
    icon: Field::CarrierwaveField,
    background_image: Field::CarrierwaveField,
    starts_at: Field::DateTime,
    expires_at: Field::DateTime,
    match_policy: Field::SelectBasic.with_options(choices: [['Match all rules', :all],['Match any rules', :any]]),
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    name
    vendors
    promotion_rules
    promotion_actions
    starts_at
    expires_at
    icon
    background_image
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    name
    description
    vendors
    promotion_rules
    promotion_actions
    starts_at
    expires_at
    icon
    background_image
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    name
    description
    vendors
    match_policy
    starts_at
    expires_at
    icon
    background_image
  ].freeze

  def display_resource(promotion)
    promotion.name
  end
end
