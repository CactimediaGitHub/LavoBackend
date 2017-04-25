module API
  module Order
    class PromotionAmountCaclulator
      include ActiveModel::Model

      attr_accessor :order, :amount

      def compute
        amount = 0
        promotions.each do |p|
          # binding.pry
          next unless p.eligible?(order)
          p.actions.each do |action|
            # binding.pry
            amount += action.compute_amount(order)
          end
        end
        amount
      end

      private

      def promotions
        @promotions ||= Promotion.active_for_vendor(order.vendor)
      end
    end
  end
end
