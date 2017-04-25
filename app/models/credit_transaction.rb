class CreditTransaction < ApplicationRecord
  include FilterablePgSearchScope

  belongs_to :customer
  validates :customer, presence: true
  validates :amount, numericality: { greater_than: 0, only_integer: true }

  enum transaction_type: {
       purchased: 'purchased',
       refunded: 'refunded',
       paid: 'paid',
       manual_addition:   'manual_addition',
       manual_withdrawal: 'manual_withdrawal'
  }
  validates :transaction_type,
     inclusion: { in: self.transaction_types.keys }

  trigger.after(:insert) do
    <<-SQL
      if (NEW.transaction_type = 'purchased' OR NEW.transaction_type = 'refunded' OR NEW.transaction_type = 'manual_addition') then
        update customers set credits_amount = credits_amount + NEW.amount WHERE id = NEW.customer_id;
      elsif (NEW.transaction_type = 'paid' OR NEW.transaction_type = 'manual_withdrawal') then
        update customers set credits_amount = credits_amount - NEW.amount WHERE id = NEW.customer_id;
      end if
    SQL
  end

  pg_search_scope(:search,
    against: [:transaction_type, :note],
    associated_against: {
      customer: [:name, :surname],
    },
  )

  def self.to_xlsx(collection)
    package = Axlsx::Package.new
    workbook = package.workbook
    workbook.add_worksheet(name: collection.model.to_s.downcase) do |sheet|
      sheet.add_row(['customer', 'amount', 'transaction type', 'created at',
                     'note', 'id'])
      collection.each do |object|
        sheet.add_row([object.customer.full_name, convert(object.amount), object.transaction_type,
                       object.created_at, object.note, object.id])
      end
    end
    package.to_stream.read
  end

  protected

  def self.convert(amount)
    Admin::Money.new(amount).format
  end
end
