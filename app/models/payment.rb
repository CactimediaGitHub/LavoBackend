class Payment < ApplicationRecord
  include FilterablePgSearchScope

  belongs_to :order
  belongs_to :card
  belongs_to :customer
  belongs_to :vendor
  validates :customer, presence: true
  validates :paid_amount, numericality: { greater_than_or_equal_to: 0, only_integer: true }

  enum payment_method: { card: 'card', credits: 'credits', card_credits: 'card_credits', cash: 'cash' }

  pg_search_scope(:search,
    against: [:payment_method, :status, :response_code, :response_message, :fort_id],
    associated_against: {
      vendor: [:name],
      customer: [:email, :name, :surname, :phone],
    },
  )

  def self.to_xlsx(collection)
    package = Axlsx::Package.new
    workbook = package.workbook
    workbook.add_worksheet(name: collection.model.to_s.downcase) do |sheet|
      sheet.add_row(['vendor', 'customer', 'card', 'order', 'payment method', 'order total',
                     'paid amount', 'credits amount', 'status', 'response code', 'fort',
                     'created at'])
      collection.each do |object|
        sheet.add_row([object.vendor.try(:name), object.customer.try(:full_name),
                       object.card.try(:id), object.order.try(:id), object.payment_method,
                       object.order_total, object.paid_amount, object.credits_amount,
                       object.status, object.response_code, object.fort_id.to_s, object.created_at])
      end
    end
    package.to_stream.read
  end

  def success?
    status == '14'
  end
end
