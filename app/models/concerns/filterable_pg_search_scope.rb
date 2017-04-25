require 'active_support/concern'

module FilterablePgSearchScope
  extend ActiveSupport::Concern

  included do
    include PgSearch

    pg_search_scope(:filter,
      -> (query, attributes) do
        raise ArgumentError unless attribute_names.include?(*attributes)
        { against: attributes, query: query }
      end
    )

    pg_search_scope(:search,
      against: searchable_attributes,
      using: {
        tsearch: {
          dictionary: 'english',
          tsvector_column: 'tsv'
        }
      },
    )
  end

  class_methods do
    def searchable_attributes
      return unless defined? "#{self}Dashboard".constantize
      @searchable_attributes ||=
        CustomerDashboard::ATTRIBUTE_TYPES.keys.select do |attr|
          CustomerDashboard::ATTRIBUTE_TYPES[attr].searchable?
        end
    end
  end

end
