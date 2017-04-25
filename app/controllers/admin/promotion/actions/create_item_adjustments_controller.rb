module Admin
  module Promotion
    module Actions
      class CreateItemAdjustmentsController < Admin::ApplicationController
        private
        def resource_params
          params.require(:promotion_actions_create_item_adjustment).permit(*permitted_attributes)
        end
      end
    end
  end
end
