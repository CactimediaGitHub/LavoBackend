require "administrate/field/base"

module Administrate
  module Field
    class NestedHoursField < Base
      def to_s
        data
      end
    end
  end
end
