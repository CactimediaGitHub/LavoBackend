require "administrate/field/base"

module Administrate
  module Field
    class NestedImageGalleryField < Base
      def urls
        data.map(&:url)
      end

      def to_s
        data
      end
    end
  end
end
