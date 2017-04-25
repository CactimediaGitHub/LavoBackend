require 'active_support/concern'
require 'administrate/field/base'
require 'administrate/field/boolean'
require 'administrate/field/select'
require 'administrate/field/deferred'

module Administrate
  module Field

    module BaseExtention
      extend ActiveSupport::Concern
      class_methods do
        def filterable?
          false
        end
      end
    end

    module FilterableExtention
      extend ActiveSupport::Concern
      class_methods do
        def filterable?
          true
        end
      end
      #
      # def filterable_options
      #   @filterable_options ||= options.fetch(:filterable_options, [])
      # end
    end

    module DeferredExtention
      extend ActiveSupport::Concern
      def filterable?
        options.fetch(:filterable, deferred_class.filterable?)
      end

      def filterable_options
        return unless filterable?
        @filterable_options ||= options.fetch(:filterable_options, [])
      end

      def display_filterable_options
        filterable_options.join(';')
      end
    end

  end
end

Administrate::Field::Base.send(:include, Administrate::Field::BaseExtention)
Administrate::Field::Boolean.send(:include, Administrate::Field::FilterableExtention)
Administrate::Field::Select.send(:include, Administrate::Field::FilterableExtention)
Administrate::Field::Deferred.send(:include, Administrate::Field::DeferredExtention)
