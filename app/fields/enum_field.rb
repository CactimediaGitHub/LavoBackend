require 'administrate/field/base'

module Administrate
  module Field
    class EnumField < Base
      def self.filterable?
        true
      end

      def to_s
        data.humanize
      end

      def selectable_options
        collection
      end

      private

      def collection
        @collection ||= options.fetch(:collection, [])
      end
    end
  end
end
