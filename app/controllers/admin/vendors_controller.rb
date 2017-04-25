module Admin
  class VendorsController < Admin::ApplicationController
    def index
      search_term = params[:search].to_s.strip
      resources = Administrate::PgSearch.new(resource_resolver, search_params).run

      resources =
        if params[:order]
          params[:order] == 'orders' ?
            resources.joins("LEFT OUTER JOIN orders ON orders.vendor_id = vendors.id ")
              .group("vendors.id")
              .order("count(orders.id) #{params[:direction]}") :
            order.apply(resources)
        else
          resources.order(cached_average_rating: :desc, name: :asc)
        end
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
        format.xlsx {
          send_data Vendor.to_xlsx(export_resources) }
      end
    end

    def create
      geocode

      resource = resource_class.new(resource_params)
      resource.schedules = Admin::CreateDefaultScheduleService.default_schedules

      if resource.save
        redirect_to(
          [namespace, resource.class],
          notice: translate_with_resource("create.success"),
        )
      else
        render :new, locals: {
          page: Administrate::Page::Form.new(dashboard, resource),
        }
      end
    end

    def update
      geocode if requested_resource.address != resource_params[:address]

      requested_resource.add_images(uploaded_files)
      super
    end

    def destroy
      if params[:delete_img].present?
        requested_resource.remove_images_by(params[:index].to_i)
        requested_resource.save
        flash[:notice] = "Image was successfully destroyed."
        redirect_to action: :show
      else
        super
      end
    end

    private

    def geocode
      lat, lon = Geocoder.coordinates(resource_params[:address])
      params[:vendor][:lat] = lat
      params[:vendor][:lon] = lon
    end

    def resource_params
      params.
        require(:vendor).
        permit(permitted_attributes, { images: [] })
    end

    def uploaded_files
      @uploaded_files = resource_params.extract!(:images)[:images]
      # NOTE: probably rails bug
      params[:vendor]&.extract!(:images)
      @uploaded_files || []
    end
  end
end
