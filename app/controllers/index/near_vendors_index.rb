module Index
  class NearVendorsIndex < BaseIndex
    DEFAULT_SORTING = { }.freeze
    SORTABLE_FIELDS = %i(cached_average_rating price).freeze
    ALLOWED_FILTERS = %i(inventory_items.service_id inventory_items.item_id).freeze
    FILTER_MATCH_TYPES = { inventory_price: true }.freeze

    def vendors(scope = Vendor)
      @vendors ||= begin
        # FIXME: Unpermitted parameter: filter
        # NOTE: selects vendors who have all selected items
        # select vendor_id, count(distinct item_id) item_id_count from inventory_items where item_id in (1,2) and service_id = 1 group by vendor_id having count(distinct item_id) = 2
        if controller.params[:sort] =~ /inventory_items/ || controller.params[:filter] =~ /.*inventory-items.*/
          filtered_records =
            scope.joins(:inventory_items).merge(filter_records(InventoryItem.all))

          @count = filtered_records.count
          filtered_records.merge(avg_price_subquery).page(current_page).per(current_size)
        else
          prepare_records(scope)
        end
      end
    end

    private

    def avg_price_subquery
      Vendor.select("vendors.*, (select avg(inventory_items.price) from inventory_items where#{filter_records(InventoryItem.all).to_sql.split('WHERE').last} group by vendor_id having(vendors.id = vendor_id)) average_price").order('average_price')
    end
  end
end
