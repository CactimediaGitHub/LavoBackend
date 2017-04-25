module Admin
  class ShippingsController < Admin::ApplicationController

    def index
      search_term = params[:search].to_s.strip
      resources = Administrate::FilterSearch.new(resource_resolver, search_term).run
      resources = order.apply(resources)
      resources = resources.page(params[:page]).per(records_per_page)
      page = Administrate::Page::Collection.new(dashboard, order: order)

      render locals: {
        resources: resources,
        search_term: search_term,
        page: page
      }
    end

  end
end
