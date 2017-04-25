# A rule to limit a promotion based on inventory items in the order.
# Require all the inventory items to be present.
# Valid items come from inventory items assingned directly to the rule.
class Promotion
  module Rules
    class OrderItemDiscount < PromotionRule

      preference :service_id, :integer
      preference :item_id, :integer
      preference :item_type_id, :integer

      # scope/association that is used to test eligibility
      def eligible_inventory_item_ids
        where_hash = {
                vendor: promotion.vendor_ids,
            service_id: preferred_service_id,
               item_id: preferred_item_id,
          item_type_id: preferences[:item_type_id]
        }
        @eligible_inventory_item_ids ||= InventoryItem.where(where_hash).ids
      end

      def applicable?(promotable)
        return true if promotable.is_a?(Order) && promotable.order_items.any? { |i| actionable?(i) }
        return true if promotable.is_a?(OrderItem) && actionable?(promotable)
      end

      def eligible?(order, options = {})
        return true if eligible_inventory_item_ids.empty?

        ids = inventory_item_ids_in_order(order)
        unless ids.find { |id| eligible_inventory_item_ids.include?(id) }
          error_message = eligibility_error_message(:no_applicable_products)
          eligibility_errors.add(:base, error_message)
        end

        eligibility_errors.empty?
      end

      def actionable?(order_item)
        eligible_inventory_item_ids.include?(order_item.inventory_item_id)
      end

      private

      def inventory_item_ids_in_order(order)
        order.order_items.map(&:inventory_item_id)
      end
    end
  end
end
