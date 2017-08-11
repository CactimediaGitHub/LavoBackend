class Vendor < ApplicationRecord
  include FilterablePgSearchScope
  include UserRelated
  include ImagesManagement

  WORKSHEET_NAME = 'Vendor-Transactions'

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

  validates :name, :address, :minimum_order_amount, presence: true
  # FIXME: set comission as separate has_many association
  validates :commission, numericality: { greater_than: 0, only_integer: true }
  validates :flat_rate, numericality: { greater_than_or_equal_to: 0, only_integer: true }
  validates :phone, format: { with: PHONE_FORMAT_REGEXP }, length: { minimum: 6, maximum: 10 }
  validates :emirate, presence: true

  scope :activated, -> { where(activated: true) }

  before_save :covert_minimum_order_amount

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
    ).sort_records(args)
  end

  def self.sort_records(args = {})
    case args[:sort]
    when 'st_proximity'
      proximity_order(args[:lat], args[:lon])
    when '-cached-average-rating'
      rating_order
    when 'inventory_items.price'
      price_order(args[:filter], args[:sort])
    end
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

  def self.rating_order
    order(cached_average_rating: :desc)
  end

  def self.price_order(filters = [], order_by_column)
    joins(:inventory_items)
    .where('inventory_items.service_id IN (?) AND inventory_items.item_id IN (?)', 
           filters[:'inventory_items.service_id'], 
           filters[:'inventory_items.item_id'])
    .order(order_by_column)
  end

  def self.select_with_distance(lat, lon)
    select(
      %(
        ST_Distance(
          ST_SetSRID(ST_Point(#{lat}, #{lon}), 4326)::geography,
          ST_SetSRID(ST_Point(lat, lon), 4326)::geography
        ), vendors.*
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

  def self.to_transactions_csv(collection)
    CSV.generate(headers: true) do |csv|
      csv << ['Vendor name', 'Total number of orders', 'Number of regular orders', 
              'Number of open baskets', 'Total transaction amount', 
              'Lavo commision amount', 'Net payable amount', 
              'Account balance']
      collection.each do |object|
        csv << [object.name, object.orders.count, object.orders.regularbasket.count,
                object.orders.openbasket.count, object.transactions.sum(&:paid_amount),
                object.commission, object.transactions.sum(&:paid_amount) - (object.orders.count - object.commission),
                object.balance]
      end
    end
  end

  def full_name
    name || email
  end

  def to_s
    full_name
  end

  def update_balance order_total
    total = ::Calculator::OrdersNetTotal.new(vendor: self, order_total: order_total).compute
    self.update_column(:balance, total)
  end

  def customer?
    false
  end

  def self.search_by_name(vendors, query)
    vendors.where('vendors.name ilike (?)', "%#{query}%")
  end

  # Fetches vendors transactions details
  def self.fetch_transaction_report(vendor_ids, start_date, end_date)
    vendor_ids = vendor_ids.compact.reject{ |vendor_id| vendor_id.strip.empty? }
    return [] if vendor_ids.blank? && start_date.blank? && end_date.blank?
    Vendor
      .where('vendors.id IN (?)', vendor_ids).includes(transactions: :order)
      .where("orders.state = 'completed'").references(:orders)
      .where('payments.created_at BETWEEN (?) AND (?)',start_date, end_date).references(:transactions)
  end

  def balance_in_aed
    balance.present? ? balance/100 : 0     
  end

  def lavo_commission
    if flat_rate && flat_rate != 0
      return "#{flat_rate.to_f} AED"
    else
      return "#{commission.to_f} %"
    end
  end

  def self.stuff_distance(vendors, serialized_vendors)
    vendor_json = {}
    vendor_json[:data] = serialized_vendors[:data].each_with_index do |serialized_vendor, index|
      serialized_vendor[:attributes][:'st-distance'] = vendors[index].st_distance
    end
    vendor_json
  end

  private

  def covert_minimum_order_amount
    self.minimum_order_amount = self.minimum_order_amount * 100 if (minimum_order_amount_was != minimum_order_amount)
  end

  protected

  def delete_dirs
    dir = "#{Rails.root}/public/#{self.images[0].store_dir}"
    FileUtils.remove_dir dir
  end
end
