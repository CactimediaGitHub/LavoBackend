require "administrate/base_dashboard"

class CardDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    customer: Field::BelongsTo,
    id: Field::Number,
    number: Field::String,
    token: Field::String,
    card_bin: Field::String,
    name: Field::String,
    expiry_date: Field::String,
    nick: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :customer,
    :id,
    :number,
    :token,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :customer,
    :id,
    :number,
    :token,
    :card_bin,
    :name,
    :expiry_date,
    :nick,
    :created_at,
    :updated_at,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :customer,
    :number,
    :token,
    :card_bin,
    :name,
    :expiry_date,
    :nick,
  ].freeze

  # Overwrite this method to customize how cards are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(card)
  #   "Card ##{card.id}"
  # end
end
