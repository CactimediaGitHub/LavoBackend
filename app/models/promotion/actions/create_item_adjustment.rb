class Promotion
  module Actions
    class CreateItemAdjustment < PromotionAction
      include CalculatedAdjustments
      include AdjustmentSource

      def perform(options = {})
        order, promotion = options[:order], options[:promotion]
        create_unique_adjustments(order, order.order_items) do |order_item|
          promotion.line_item_actionable?(order, order_item)
        end
      end

      def compute_amount(promotable)
        return compute_amount_order_item(promotable) if promotable.is_a?(OrderItem)

        promotable.order_items.reduce(0) do |amount, order_item|
          if promotion.line_item_actionable?(promotable, order_item)
            amount + [order_item.total, compute(order_item)].min * -1
          else
            amount
          end
        end
      end

      private

      def compute_amount_order_item(order_item)
        return 0 unless promotion.line_item_actionable?(order_item.order, order_item)
        [order_item.total, compute(order_item)].min * -1
      end
    end
  end
end
