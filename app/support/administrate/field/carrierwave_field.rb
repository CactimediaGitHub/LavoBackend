require "administrate/field/base"

module Administrate
  module Field
    class CarrierwaveField < Base
      def url
        data&.url
      end

      def to_s
        data
      end
    end
  end
end
