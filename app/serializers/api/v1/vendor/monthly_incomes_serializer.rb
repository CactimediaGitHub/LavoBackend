class API::V1::Vendor::MonthlyIncomesSerializer < ActiveModel::Serializer
  attributes %i(month orders_completed total_transactions commission net_amount)
  def id
    TokenGenerator.uuid
  end

  type :monthly_incomes
end