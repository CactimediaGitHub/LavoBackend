module Admin
  class CreditTransactionsController < Admin::ApplicationController
    before_action :update_price, only: :create

    def index
      search_term = params[:search].to_s.strip
      # search_term = Admin::Money.to_cents(search_term).to_s unless (search_term.match(/customer/) || search_term.empty?)
      resources = Administrate::PgSearch.new(resource_resolver, search_params).run
      resources = order.apply(resources)
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
        format.xlsx { send_data CreditTransaction.to_xlsx(resources) }
      end
    end

    protected

    def update_price
      API::V1::Support::ConvertToCents.new(params: params, parent_key: :credit_transaction, child_key: :amount).convert
    rescue => e
      flash.now[:error] = e.message
    end
  end
end
