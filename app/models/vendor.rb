class Vendor < ApplicationRecord
  include FilterablePgSearchScope
  include UserRelated
  include ImagesManagement

  # FIXME: write a custom trigger to update tsv for searching against cached_average_rating
  pg_search_scope(:search,
    against: [:name, :address, :email, :phone],
    using: {
      tsearch: {
        dictionary: 'english',
        tsvector_column: 'tsv'
      }
    },
    order_within_rank: 'cached_average_rating desc'
  )

  has_many :inventory_items, -> { order(service_id: :asc, item_id: :asc) }

  with_options(through: :inventory_items) do |o|
    o.has_many :services, -> { distinct }
    o.has_many :items,    -> { distinct }
    o.has_many :item_types,    -> { distinct }
  end

  has_many :shipping_methods
  has_many :orders
  has_many :completed_orders, -> { where(state: :completed) }, class_name: 'Order'
  has_many :payouts
  has_many :transactions, foreign_key: :vendor_id, class_name: 'Payment'
  has_many :schedules
  has_many :holidays

  has_many :vendor_promotions
  has_many :promotions, through: :vendor_promotions, class_name: 'Promotion'

  # NOTE: Vendor.all.map {|v| [v, v.items.select('items.*, services.name as sn').group_by(&:sn)] }

  # OPTIMIZE: consider storing in the cloud
  # NOTE: add thumb, full image sizes
  # OPTIMIZE: add image host
  mount_uploaders :images, GalleryUploader
  after_destroy :delete_dirs

  # NOTE: do not set 'by: :customers' option as it overwrites existing Customer#reviews
  is_reviewable scale: (0..5)

  validates :name, :address, presence: true
  # FIXME: set comission as separate has_many association
  validates :commission, numericality: { greater_than: 0, only_integer: true }
  validates :flat_rate, numericality: { greater_than_or_equal_to: 0, only_integer: true }
  validates :phone, format: { with: PHONE_FORMAT_REGEXP }, length: { minimum: 7, maximum: 11 }

  scope :activated, -> { where(activated: true) }

  def self.permitted_attributes
    %i(email password password_confirmation avatar name phone address)
  end

  def self.near(args = {})
    where(
      %(
        ST_DWithin(
          ST_SetSRID(ST_Point(:lat,:lon),4326)::geography,
          ST_SetSRID(ST_Point(lat,lon),4326)::geography,
          :radius
        )
      ),
      lat: args[:lat],
      lon: args[:lon],
      radius: args.fetch(:radius, 5000)
    ).proximity_order(args[:lat], args[:lon])
  end

  def self.withing(args = {})
    polygon = format('POLYGON((%{ne}, %{nw}, %{sw}, %{se}, %{ne}))', args)
    where(
      %(
        ST_Within(
          ST_SetSRID(ST_Point(lat,lon),4326),
          ST_GeomFromText('#{polygon}',4326)
        )
      )
    )
  end

  def self.proximity_order(lat, lon)
    order(
      %(
        ST_Distance(
          ST_SetSRID(ST_Point(#{lat}, #{lon}), 4326)::geography,
          ST_SetSRID(ST_Point(lat, lon), 4326)::geography
        )
      )
    )
  end

  def self.to_xlsx(collection)
    package = Axlsx::Package.new
    workbook = package.workbook
    workbook.add_worksheet(name: collection.model.to_s.downcase) do |sheet|
      sheet.add_row(['name', 'phone', 'email', 'orders', 'balance',
                     'cached average rating', 'cached total rating',
                     'transactions'])
      collection.each do |object|
        sheet.add_row([object.name, object.phone, object.email, object.orders.count,
                       object.balance, object.cached_average_rating,
                       object.cached_total_reviews,
                       object.transactions.sum(:order_total)])
      end
    end
    package.to_stream.read
  end

  def full_name
    name || email
  end

  def to_s
    full_name
  end

  def update_balance
    total = ::Calculator::OrdersNetTotal.new(vendor: self).compute
    self.update_column(:balance, total)
  end

  def customer?
    false
  end

  protected

  def delete_dirs
    dir = "#{Rails.root}/public/#{self.images[0].store_dir}"
    FileUtils.remove_dir dir
  end
end
