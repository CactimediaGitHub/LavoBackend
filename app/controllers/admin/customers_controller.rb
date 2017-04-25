module Admin
  class CustomersController < Admin::ApplicationController
    def index
      search_term = params[:search].to_s.strip
      resources = Administrate::PgSearch.new(resource_resolver, search_params).run
      resources = params[:order] == 'orders' ?
        resources.joins("LEFT OUTER JOIN orders ON orders.customer_id = customers.id ")
          .group("customers.id")
          .order("count(orders.id) #{params[:direction]}") :
        order.apply(resources)
      export_resources = resources.joins(:orders).distinct
      resources = resources.page(params[:page]).per(records_per_page)
      page = Administrate::Page::Collection.new(dashboard, order: order)

      respond_to do |format|
        format.html {
          render locals: {
            resources: resources,
            search_term: search_term,
            page: page,
          }
        }
        format.xlsx { send_data Customer.to_xlsx(export_resources) }
      end
    end
  end
end
