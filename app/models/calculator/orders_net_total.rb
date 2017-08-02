class Calculator
  class OrdersNetTotal
    include ActiveModel::Model

    attr_accessor :vendor
    attr_accessor :order_total

    def compute
      if vendor.flat_rate && vendor.flat_rate != 0
        (vendor.balance + (order_total - (vendor.flat_rate * 100))).to_i
      elsif vendor.commission && vendor.commission != 0
        (vendor.balance + (order_total * ((100 - vendor.commission.to_f)/100))).to_i
      else
        vendor.balance
      end
    end

    private

    def total
      @total ||= vendor.completed_orders.sum(:total)
    end
  end
end
