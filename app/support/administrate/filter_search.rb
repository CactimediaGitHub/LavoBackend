require "active_support/core_ext/module/delegation"
require "active_support/core_ext/object/blank"

module Administrate
  class FilterSearch < Search
    FILTER_SEARCH_TERM_REGEXP = /f\[(.*?)\]/.freeze

    def initialize(resolver, term)
      @resolver = resolver
      @term = term
    end

    def run
      if @term.blank?
        resource_class.all
       elsif @term =~ FILTER_SEARCH_TERM_REGEXP
        filter_records(resource_class.all)
      else
        resource_class.where(query, *search_terms)
      end
    end

    private

    delegate :resource_class, to: :resolver

    def query
      search_attributes.map { |attr| "lower(#{attr}::text) LIKE ?" }.join(" OR ")
    end

    def search_terms
      ["%#{term.downcase}%"] * search_attributes.count
    end

    def search_attributes
      attribute_types.keys.select do |attribute|
        attribute_types[attribute].searchable?
      end
    end

    def attribute_types
      resolver.dashboard_class::ATTRIBUTE_TYPES
    end

    def filter_records(records)
      Queries::Filter.filter(records, filter_params, {})
    end

    #NOTE: returns {customer_id: [1,2], vendor_id: [1]}
    def filter_params
      return {} unless term.is_a?(String)
      filters =
        term.split('&').map do |f|
          next unless filter_attribute_valid?(f)
          f.split('=').map do |z|
            if match = FILTER_SEARCH_TERM_REGEXP.match(z)
              match[1] == 'id' ? match[1] : "#{match[1]}_id"
            else
              z.split(',')
            end
          end
        end.compact.to_h
    end

    def filter_attribute_valid?(search_term)
      attributes = attribute_types.keys.map(&:to_s)
      user_entered_attribute = FILTER_SEARCH_TERM_REGEXP.match(search_term)[1]
      attributes.include?(user_entered_attribute)
    end

    attr_reader :resolver, :term
  end
end
