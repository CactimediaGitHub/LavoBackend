require "administrate/field/base"

module Administrate
  module Field
    class AmountFormat < Administrate::Field::Number
      def to_s
        if data.nil?
          "-"
        else
          Admin::Money.new(data).format
        end
      end
    end
  end
end
