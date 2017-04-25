class Customer < ApplicationRecord

  attr_accessor :activation_token

  include UserRelated
  include FilterablePgSearchScope

  has_many :addresses

  has_many :reviews, -> { of_reviewable_type(Vendor) }, as: :reviewer
  has_many :orders
  has_many :credit_transactions
  has_many :cards
  has_many :transactions, foreign_key: :customer_id, class_name: 'Payment'

  validates :phone,
            length: {in: 7..11, allow_blank: true},
            format: { with: PHONE_FORMAT_REGEXP, allow_blank: true }

  pg_search_scope(:search,
    against: [:email, :name, :surname, :phone],
    associated_against: {
      addresses: [:address1, :address2, :city, :country, :nearest_landmark]
    },
    using: {
      tsearch: {
        dictionary: 'english',
        tsvector_column: 'tsv'
      }
    },
  )

  def self.permitted_attributes
    [:email, :password, :password_confirmation, :avatar,
     :name, :surname, :phone]
  end

  def self.to_xlsx(collection)
    package = Axlsx::Package.new
    workbook = package.workbook
    workbook.add_worksheet(name: collection.model.to_s.downcase) do |sheet|
      sheet.add_row(['email', 'name', 'surname', 'address', 'phone', 'orders',
                     'credits amount', 'activated', 'id', 'created at',
                     'transactions'])
      collection.each do |object|
        sheet.add_row([object.email, object.name, object.surname,
                       "#{object.addresses.count} addresses", object.phone,
                       "#{object.orders.count} orders", object.credits_amount,
                       object.activated.to_s, object.id, object.created_at,
                       object.transactions.sum(:order_total)])
      end
    end
    package.to_stream.read
  end

  def address
    addresses.last.to_s
  end

  def tsv_addresses
    addresses.map(&:to_s).join('; ')
  end

  def full_name
    if name.present? or surname.present?
      [name, surname].compact.join(' ')
    else
      email
    end
  end

  def customer?
    true
  end
end
