module Admin
  class ReviewsController < Admin::ApplicationController
    def index
      search_term = params[:search].to_s.strip
      resources = Administrate::Search.new(resource_resolver, search_term).run
      resources = order.apply(resources)
      resources = resources.all_reviews.page(params[:page]).per(records_per_page)
      page = Administrate::Page::Collection.new(dashboard, order: order)

      render locals: {
        resources: resources,
        search_term: search_term,
        page: page,
      }
    end

    def destroy
      requested_resource.destroy
      requested_resource.reviewable.send(:update_cache!)
      flash[:notice] = translate_with_resource("destroy.success")
      redirect_to action: :index
    end
  end
end
