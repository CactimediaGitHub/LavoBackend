module Admin
  class SchedulesController < Admin::ApplicationController
    def index
      search_term = params[:search].to_s.strip
      resources = Administrate::PgSearch.new(resource_resolver, search_params).run
      resources = order.apply(resources)
      resources = resources.page(params[:page]).per(records_per_page)
      page = Administrate::Page::Collection.new(dashboard, order: order)

      render locals: {
        resources: resources,
        search_term: search_term,
        page: page,
      }
    end

    def resource_params
      params.require(:schedule).permit(
        permitted_attributes,
        hours: [
          :"0-2",
          :"2-4",
          :"4-6",
          :"6-8",
          :"8-10",
          :"10-12",
          :"12-14",
          :"14-16",
          :"16-18",
          :"18-20",
          :"20-22",
          :"22-24"
        ]
      )
    end

  end
end
