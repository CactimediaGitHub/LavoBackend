module Admin
  class ShippingMethodsController < Admin::ApplicationController
    before_action :update_price, only: %i(create update)
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
          resources.order(vendor_id: :asc)
        end
      resources = resources.includes(:vendor).page(params[:page]).per(records_per_page)
      page = Administrate::Page::Collection.new(dashboard, order: order)

      render locals: {
        resources: resources,
        search_term: search_term,
        page: page,
      }
    end

    protected

    def update_price
      API::V1::Support::ConvertToCents.new(params: params, parent_key: :shipping_method, child_key: :shipping_charge).convert
    end

    # Define a custom finder by overriding the `find_resource` method:
    # def find_resource(param)
    #   ShippingMethod.find_by!(slug: param)
    # end

    # See https://administrate-docs.herokuapp.com/customizing_controller_actions
    # for more information
  end
end
