class Promotion
  module Calculators
    class FlatPercent < Calculator
      preference :amount, :integer, default: 0

      def self.description
        scope = [:activerecord, :models, :'promotion/calculators/flat_percent']
        I18n.t(:description, scope: scope)
      end

      def compute(object)
        computed_amount = (object.total * preferred_amount.to_f/100).to_i

        if computed_amount > object.total
          object.total
        else
          computed_amount
        end
      end
    end
  end
end
