class Payout < ApplicationRecord
  include FilterablePgSearchScope

  belongs_to :vendor

  validates :vendor, presence: true
  validates :amount, numericality: { greater_than: 0, only_integer: true }

  enum payment_status: {
       pending: 'pending',
       partial: 'partial',
       completed: 'completed',
  }
  validates :payment_status, inclusion: { in: self.payment_statuses.keys }

  trigger.after(:insert) do
    <<-SQL
      update vendors set balance = balance - NEW.amount WHERE id = NEW.vendor_id;
    SQL
  end

  pg_search_scope(:search,
    against: [:payment_status, :note],
    associated_against: {
      vendor: [:name],
    },
  )

end
