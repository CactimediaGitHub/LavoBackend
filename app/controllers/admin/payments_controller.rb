module Admin
  class PaymentsController < Admin::ApplicationController
    before_action :update_price, only: %i(create update)
    # To customize the behavior of this controller,
    # simply overwrite any of the RESTful actions. For example:
    #
    def index
      search_term = params[:search].to_s.strip
      resources = Administrate::PgSearch.new(resource_resolver, search_params).run
      if params[:order]
        resources = order.apply(resources)
      else
        resources = resources.order(created_at: :desc)
      end
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
        format.xlsx { send_data Payment.to_xlsx(resources) }
      end
    end

    protected

    def update_price
      API::V1::Support::ConvertToCents.new(params: params, parent_key: :payment, child_key: :paid_amount).convert
      API::V1::Support::ConvertToCents.new(params: params, parent_key: :payment, child_key: :order_total).convert
    end

    # Define a custom finder by overriding the `find_resource` method:
    # def find_resource(param)
    #   Payment.find_by!(slug: param)
    # end

    # See https://administrate-docs.herokuapp.com/customizing_controller_actions
    # for more information
  end
end
