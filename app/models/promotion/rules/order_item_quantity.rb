# A rule to limit a promotion based on products in the order.
# Can require all or any of the products to be present.
# Valid products either come from assigned product group or are assingned directly to the rule.
class Promotion
  module Rules
    class OrderItemQuantity < PromotionRule

      preference :order_item_quantity, :integer, default: 2

      # scope/association that is used to test eligibility
      # TODO: use vendors association to get eligible items
      def eligible_items
        @eligible_items ||= ::InventoryItem.where(vendor: promotion.vendors)
      end

      def applicable?(promotable)
        return true if promotable.is_a?(Order)
        # return true if promotable.is_a?(Order) && promotable.order_items.any? { |i| actionable?(i) }
        return true if promotable.is_a?(OrderItem)
        # return true if promotable.is_a?(OrderItem) && actionable?(promotable)
      end

      def eligible?(order, options = {})
        # return true if eligible_items.empty?

        # if preferred_match_policy == 'all'
        #   unless eligible_items.all? {|p| order.products.include?(p) }
        #     eligibility_errors.add(:base, eligibility_error_message(:missing_product))
        #   end
        # elsif preferred_match_policy == 'any'
        #   unless order.products.any? {|p| eligible_items.include?(p) }
        #     eligibility_errors.add(:base, eligibility_error_message(:no_applicable_products))
        #   end
        # else
        #   unless order.products.none? {|p| eligible_items.include?(p) }
        #     eligibility_errors.add(:base, eligibility_error_message(:has_excluded_product))
        #   end
        # end
        unless order.order_items.any? do |order_item|
            eligible_items.include?(order_item.inventory_item) && order_item.quantity >= preferred_order_item_quantity
          end
          eligibility_errors.add(:base, eligibility_error_message(:no_applicable_products))
        end


        eligibility_errors.empty?
      end

      def actionable?(order_item)
        order_item.quantity >= preferred_order_item_quantity
      end

      def product_ids_string
        product_ids.join(',')
      end

      def product_ids_string=(s)
        self.product_ids = s.to_s.split(',').map(&:strip)
      end
    end
  end
end
