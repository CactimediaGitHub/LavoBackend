# All Administrate controllers inherit from this `Admin::ApplicationController`,
# making it the ideal place to put authentication logic or other
# before_filters.
#
# If you want to add pagination or other controller-level concerns,
# you're free to overwrite the RESTful controller actions.
module Admin
  class ApplicationController < Administrate::ApplicationController
    
    http_basic_authenticate_with(
      name: ENV.fetch('ADMIN_NAME'),
      password: ENV.fetch('ADMIN_PASSWORD')
    )

    def promotion_type_helper(resource)
      case resource
      when PromotionRule
        resource.becomes(PromotionRule)
      when PromotionAction
        resource.becomes(PromotionAction)
      else
        resource
      end
    end
    helper_method :promotion_type_helper

    def create
      resource = resource_class.new(resource_params)
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
      if requested_resource.update(resource_params)
        redirect_to(
          [namespace, requested_resource.class],
          notice: translate_with_resource("update.success"),
        )
      else
        render :edit, locals: {
          page: Administrate::Page::Form.new(dashboard, requested_resource),
        }
      end
    end

    def destroy
      requested_resource.destroy
      flash[:notice] = translate_with_resource("destroy.success")
      redirect_to action: :index
    end

    private

    def search_attributes
      attribute_types.keys.select do |attribute|
        attribute_types[attribute].searchable?
      end
    end

    def filter_attributes
      @filter_attributes ||=
        attribute_types.keys.select do |attribute|
          attribute_types[attribute].filterable?
        end
    end
    helper_method :filter_attributes

    def filterable_attribute?(attr_name)
      filter_attributes.include?(attr_name.to_s.to_sym)
    end
    helper_method :filterable_attribute?

    def attribute_types
      resource_resolver.dashboard_class::ATTRIBUTE_TYPES
    end

    def search_params
      params.permit(:search, filter: filter_attributes)
    end

    # Override this value to specify the number of elements to display at a time
    # on index pages. Defaults to 20.
    # def records_per_page
    #   params[:per_page] || 20
    # end
  end
end
