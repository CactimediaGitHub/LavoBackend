class Promotion
  module Actions
    class CreateAdjustment < PromotionAction
      include CalculatedAdjustments
      include AdjustmentSource

      def perform(options = {})
        order = options[:order]
        create_unique_adjustment(order, order)
      end

      def compute_amount(order)
        [order.total, compute(order)].min * -1
      end

    end
  end
end
