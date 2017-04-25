require "administrate/base_dashboard"

class PromotionActionDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    promotion: Field::BelongsTo,
    id: Field::Number,
    type: Field::String,
    deleted_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :promotion,
    :id,
    :type,
    :deleted_at,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :promotion,
    :id,
    :type,
    :deleted_at,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :promotion,
    :type,
    :deleted_at,
  ].freeze

  # Overwrite this method to customize how promotion actions are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(promotion_action)
  #   "PromotionAction ##{promotion_action.id}"
  # end
end
