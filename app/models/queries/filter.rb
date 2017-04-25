module Queries
  class Filter
    def self.filter(records, filters, filter_types)
      return inventory_price_filter(records, filters, filter_types) if inventory_price_filters?(filters, filter_types)

      filters.each do |field_name, value|
        filter_type = filter_types[field_name]
        if filter_type
          like_query = extract_like_query(filter_type)
          records = records.where(
            "lower(#{field_name}) LIKE lower(concat(#{like_query}))",
            value
          )
        else
          records = records.where(field_name => value)
        end
      end
      records
    end

    def self.extract_like_query(filter_type)
      case filter_type
      when :contains then "'%', ?, '%'"
      when :starts_with then "?, '%'"
      when :ends_with then "'%', ?"
      else
        raise ArgumentError, "unknown filter_type: '#{filter_type}'"
      end
    end

    private

    def self.inventory_price_filter(records, filters, filter_types)
      filters[:'inventory_items.item_id'].map do |value|
        records.
          where('inventory_items.service_id' => filters[:'inventory_items.service_id']).
          where(:'inventory_items.item_id' => value)
      end.reduce { |result, rec| result.or(rec) }
    end

    def self.inventory_price_filters?(filters, filter_types)
      filters[:"inventory_items.service_id"] &&
      filters[:"inventory_items.item_id"].present? &&
      filter_types[:inventory_price]
    end
  end
end