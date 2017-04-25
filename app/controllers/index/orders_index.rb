module Index
  class OrdersIndex < BaseIndex
    ALLOWED_FILTERS = %i(state created_at).freeze
    TRANSFORMABLE_FILTERS = { created_at: :human_time_range }.freeze
    SORTABLE_FIELDS = %i(created_at).freeze
    MAX_PER_PAGE = 4

    def orders(scope = Order)
      @orders ||= prepare_records(scope)
    end
  end
end
