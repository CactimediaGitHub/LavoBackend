class Calculator
  class OrdersNetTotal
    include ActiveModel::Model

    attr_accessor :vendor

    def compute
      if vendor.flat_rate && vendor.flat_rate != 0
        (total - vendor.flat_rate).to_i
      elsif vendor.commission && vendor.commission != 0
        (total * ((100 - vendor.commission.to_f)/100)).to_i
      else
        total
      end
    end

    private

    def total
      @total ||= vendor.completed_orders.sum(:total)
    end
  end
end
