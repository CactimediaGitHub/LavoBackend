module SortParams
  def self.sorted_fields(sort, allowed, default)
    allowed = allowed.map(&:to_s)
    fields = sort.to_s.split(',')

    ordered_fields = convert_to_ordered_hash(fields)
    filtered_fields = ordered_fields.select { |key, value| allowed.include?(key) }

    filtered_fields.present? ? filtered_fields : default
  end

  def self.convert_to_ordered_hash(fields)
    fields.each_with_object({}) do |field, hash|
      # OPTIMIZE:
      # remove table name. Order will be merged later like so Vendor.merge(InventoryItem.order(sort_params))
      field.sub!(/\w+\./, '') if field.include?('.')
      if field.start_with?('-')
        field = field[1..-1]
        hash[field.underscore] = :desc
      else
        hash[field.underscore] = :asc
      end
    end
  end
end