class Promotion
  module Calculators
    class FlatRate < Calculator
      preference :amount, :integer, default: 0

      def self.description
        scope = [:activerecord, :models, :'promotion/calculators/flat_rate']
        I18n.t(:description, scope: scope)
      end

      def compute(object=nil)
        if object.total > preferred_amount
          preferred_amount
        else
          0
        end
      end
    end
  end
end
