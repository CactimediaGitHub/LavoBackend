require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/object/blank'

module Administrate
  class PgSearch
    def initialize(resolver, params)
      @resolver = resolver
      @search_term = params.fetch(:search, '').to_s.strip
      @filters = params.fetch(:filter, {})
    end

    def run
      return resource_class.all if search_term.blank?   and filters.blank?
      return search_result      if search_term.present? and filters.blank?
      return filter_result      if search_term.blank?   and filters.present?

      filter_result.search(search_term)
    end

    private
    delegate :resource_class, to: :resolver

    def filter_result
      @filter_result ||=
        filters.reduce(resource_class) do |relation, (key, value)|
          relation = relation.filter(value, key)
        end
    end

    def search_result
      @search_result ||= resource_class.all.search(search_term)
    end

    attr_reader :search_term, :filters, :resolver
  end
end
