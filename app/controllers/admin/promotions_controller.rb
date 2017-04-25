module Admin
  class PromotionsController < Admin::ApplicationController
    def index
      search_term = params[:search].to_s.strip
      resources = Administrate::Search.new(resource_resolver, search_term).run
      resources =
        if params[:order]
          order.apply(resources)
        else
          resources.order(starts_at: :desc, expires_at: :desc)
        end
      resources = resources.page(params[:page]).per(records_per_page)
      page = Administrate::Page::Collection.new(dashboard, order: order)

      render locals: {
        resources: resources,
        search_term: search_term,
        page: page,
      }
    end
  end
end
