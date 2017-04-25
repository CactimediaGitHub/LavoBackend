require "administrate/base_dashboard"

class CustomerDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    email: Field::Email.with_options(searchable: true),
    name: Field::String.with_options(searchable: true),
    surname: Field::String.with_options(searchable: true),
    addresses: Field::HasMany,
    phone: Field::String.with_options(searchable: true),
    activated: Field::Boolean.with_options(searchable: true, filterable: true, filterable_options: [true, false]),
    http_token: Field::HasOne,
    reviews: Field::HasMany,
    orders: Field::HasMany.with_options(limit: 100),
    id: Field::Number,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    password_digest: Field::String.with_options(searchable: false),
    avatar: Field::String.with_options(searchable: false),
    reset_digest: Field::String.with_options(searchable: false),
    reset_sent_at: Field::DateTime,
    activation_digest: Field::String.with_options(searchable: false),
    password: Field::String.with_options(searchable: false),
    password_confirmation: Field::String.with_options(searchable: false),
    credits_amount: Field::AmountFormat,
    transactions: TransactionSumField
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    email
    name
    surname
    addresses
    phone
    orders
    credits_amount
    activated
    id
    created_at
    transactions
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    email
    name
    surname
    addresses
    phone
    orders
    credits_amount
    activated
    id
    created_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    email
    name
    surname
    phone
    activated
    password
    password_confirmation
  ].freeze

  # Overwrite this method to customize how customers are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(customer)
    customer.full_name
  end
end
