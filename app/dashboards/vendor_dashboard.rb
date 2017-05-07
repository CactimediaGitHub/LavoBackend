require 'administrate/base_dashboard'
require 'nested_image_gallery_field'


class VendorDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    name: Field::String.with_options(searchable: true),
    phone: Field::String.with_options(searchable: true),
    email: Field::Email.with_options(searchable: true),
    cached_average_rating: Field::Number.with_options(decimals: 2, searchable: true),
    id: Field::Number.with_options(searchable: true),
    activated: Field::Boolean.with_options(filterable: true, filterable_options: [true, false]),
    password: Field::String.with_options(searchable: false),
    password_confirmation: Field::String.with_options(searchable: false),
    http_token: Field::HasOne,
    inventory_items: Field::HasMany.with_options(limit: 100),
    shipping_methods: Field::HasMany.with_options(limit: 100),
    orders: Field::HasMany.with_options(limit: 100),
    reviews: Field::HasMany.with_options(limit: 100),
    payouts: Field::HasMany.with_options(limit: 100),
    schedules: Field::HasMany.with_options(limit: 100),
    password_digest: Field::String.with_options(searchable: false),
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    avatar: Field::CarrierwaveField.with_options(searchable: false),
    reset_digest: Field::String.with_options(searchable: false),
    reset_sent_at: Field::DateTime,
    activation_digest: Field::String.with_options(searchable: false),
    address: Field::String,
    lat: Field::Number.with_options(decimals: 6),
    lon: Field::Number.with_options(decimals: 6),
    cached_total_reviews: Field::Number,
    commission: Field::Number,
    flat_rate: Field::Number,
    balance: Field::AmountFormat,
    images: Field::NestedImageGalleryField.with_options(searchable: false),
    transactions: TransactionSumField
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    name
    activated
    phone
    email
    orders
    balance
    cached_average_rating
    cached_total_reviews
    transactions
    commission
    flat_rate
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  # avatar
  # images
  SHOW_PAGE_ATTRIBUTES = %i(
    id
    name
    commission
    flat_rate
    balance
    payouts
    inventory_items
    orders
    email
    phone
    address
    lat
    lon
    activated
    shipping_methods
    cached_average_rating
    cached_total_reviews
    reviews
    avatar
    images
    schedules
    created_at
    updated_at
  ).freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :email,
    :name,
    :commission,
    :flat_rate,
    :phone,
    :address,
    :lat,
    :lon,
    :activated,
    :password,
    :password_confirmation,
    :avatar,
    :images
  ].freeze

  # Overwrite this method to customize how vendors are displayed
  # across all pages of the admin dashboard.
  def display_resource(vendor)
    vendor.name
  end
end
