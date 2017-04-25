class API::V1::Vendor::MonthlyIncomes
  include ActiveModel::Model
  include ActiveModel::Serialization

  attr_accessor :month, :orders_completed, :total_transactions, :commission

  def net_amount
    (total_transactions - total_transactions * commission.to_f / 100).to_i
  end
end
