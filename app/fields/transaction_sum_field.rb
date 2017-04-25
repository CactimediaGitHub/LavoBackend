require "administrate/field/has_many"

class TransactionSumField < Administrate::Field::HasMany
  def to_s
    data
  end

  def sum
    total_in_cents = data.sum(:order_total)
    Admin::Money.new(total_in_cents).format
  end
end
