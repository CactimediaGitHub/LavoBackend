module Admin
  module Promotion
    module Rules
      class OrderItemQuantitiesController < Admin::ApplicationController
        private
        def resource_params
          params.require(:promotion_rules_order_item_quantity).permit(*permitted_attributes)
        end
      end
    end
  end
end
