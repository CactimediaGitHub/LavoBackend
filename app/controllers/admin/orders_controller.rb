module Admin
  class OrdersController < Admin::ApplicationController
    include ActionController::MimeResponds
    # To customize the behavior of this controller,
    # simply overwrite any of the RESTful actions. For example:
    #
    def index
      search_term = params[:search].to_s.strip
      resources = Administrate::PgSearch.new(resource_resolver, search_params).run
      resources =
        if params[:order]
          order.apply(resources)
        else
          resources.order(created_at: :desc, state: :asc, vendor_id: :asc)
        end
      resources = resources.page(params[:page]).per(records_per_page)
      page = Administrate::Page::Collection.new(dashboard, order: order)


      respond_to do |format|
        format.html { render locals: {resources: resources, search_term: search_term, page: page, } }
        format.xlsx { send_data Order.to_xlsx(resources) }
      end
    end

    # Define a custom finder by overriding the `find_resource` method:
    # def find_resource(param)
    #   Order.find_by!(slug: param)
    # end

    # See https://administrate-docs.herokuapp.com/customizing_controller_actions
    # for more information
  end
end

# NOTE: https://github.com/thoughtbot/administrate/issues/278
module Administrate
  class OrderSearch < Search
    SEARCH_TABLES = %w(orders vendors customers addresses)

    def run
      if @term.blank?
        resource_class.all
      else
        resource_class.
          uniq.
          joins(:vendor, :customer, :address).
          where(query, *search_terms)
      end
    end

    private

    def query
      prefixed_attributes.map { |attr| "lower(#{attr}) LIKE ?" }.join(' OR ')
    end

    def search_terms
      ["%#{term.downcase}%"] * prefixed_attributes.count
    end

    def prefixed_attributes
      # FIXME: column reference "state" is ambiguous
      # search_attributes + SEARCH_TABLES.flat_map do |table|
      SEARCH_TABLES.flat_map do |table|
        attributes_for(table).map { |attr| "#{table}.#{attr}" }
      end
    end

    def attributes_for(dashboard)
      Object.const_get(dashboard.classify + 'Dashboard')::ATTRIBUTE_TYPES.select do |_, type|
        type.searchable?
      end.keys
    end
  end
end
