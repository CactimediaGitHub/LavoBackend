class API::V1::Vendor::MonthlyIncomesController < API::V1::VersionController
  before_action :authenticate

  def show
    orders_completed =
      current_user.
      completed_orders.
      group_by_month(:created_at, format: "%b %Y").count

    total_transactions =
      current_user.
      completed_orders.
      group_by_month(:created_at, format: "%b %Y").sum(:total)

    incomes =
      orders_completed.keys.map do |key|
        API::V1::Vendor::MonthlyIncomes.new(
          month: key.upcase,
          orders_completed: orders_completed[key],
          total_transactions: total_transactions[key],
          commission: current_user.commission
        )
      end
    render json: incomes
  end

  # def show
  #   orders_completed =
  #     current_user.
  #     completed_orders.
  #     group("date_trunc('month', created_at)").count
  #
  #   total_transactions =
  #     current_user.
  #     completed_orders.
  #     group("date_trunc('month', created_at)").sum(:total)
  #
  #   incomes =
  #     orders_completed.keys.map do |key|
  #       API::V1::Vendor::MonthlyIncomes.new(
  #         month: key.strftime('%b %Y').upcase,
  #         orders_completed: orders_completed[key],
  #         total_transactions: total_transactions[key],
  #         commission: current_user.commission
  #       )
  #     end
  #   render json: incomes
  # end
end
