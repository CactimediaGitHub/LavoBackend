module Admin
  class PayoutsController < Admin::ApplicationController
    before_action :update_amount, only: %i(create update)

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

    protected

    def update_amount
      API::V1::Support::ConvertToCents.new(params: params, parent_key: :payout, child_key: :amount).convert
    end
  end
end
