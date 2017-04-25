class Calculator
  class OrdersNetTotal
    include ActiveModel::Model

    attr_accessor :vendor

    def compute
      (total - total * vendor.commission.to_f / 100).to_i
    end

    private

    def total
      @total ||= vendor.completed_orders.sum(:total)
    end
  end
end
