# A rule to apply to an order greater than (or greater than or equal to)
# a specific amount
class Promotion
  module Rules
    class OrderTotal < PromotionRule
      include ActiveModel::Validations

      # FIXME: use integer for :amount_min, :amount_max
      preference :amount_min, :decimal, default: 10000
      preference :operator_min, :string, default: '>'
      preference :amount_max, :decimal, default: 100000
      preference :operator_max, :string, default: '<'

      # TODO I18n
      validates :preferred_amount_min, numericality: { greater_than_or_equal_to: 0, less_than: :preferred_amount_max, message: I18n.t(:preferred_amount_min) }
      validates :preferred_amount_max, numericality: { greater_than_or_equal_to: :preferred_amount_min, message: I18n.t(:preferred_amount_max) }

      OPERATORS_MIN = ['gt', 'gte']
      OPERATORS_MAX = ['lt','lte']

      def applicable?(promotable)
        promotable.is_a?(Order)
      end

      def eligible?(order, options = {})
        # NOTE: order.total not set in cart calculator
        # FIXME: set order total in cart calculator (without promotion discount)
        total = order.total
        check_eligiability_for(total)
      end

      def eligible_cart?(object)
        if object.is_a?(API::Order::CartCalculator)
          total = object.shipping_amount + object.subtotal

          check_eligiability_for(total)
        end
      end

      private

      def check_eligiability_for(total)
        lower_limit_condition = total.send(preferred_operator_min == 'gte' ? :>= : :>, preferred_amount_min)
        upper_limit_condition = total.send(preferred_operator_max == 'lte' ? :<= : :<, preferred_amount_max)

        eligibility_errors.add(:base, ineligible_message_max) unless upper_limit_condition
        eligibility_errors.add(:base, ineligible_message_min) unless lower_limit_condition

        eligibility_errors.empty?
      end

      def ineligible_message_max
        if preferred_operator_max == 'gte'
          eligibility_error_message(:total_more_than_or_equal, amount: preferred_amount_max)
        else
          eligibility_error_message(:total_more_than, amount: preferred_amount_max)
        end
      end

      def ineligible_message_min
        if preferred_operator_min == 'gte'
          eligibility_error_message(:total_less_than, amount: preferred_amount_min)
        else
          eligibility_error_message(:total_less_than_or_equal, amount: preferred_amount_min)
        end
      end

    end
  end
end
