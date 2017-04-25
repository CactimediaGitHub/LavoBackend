module Admin
  module Promotion
    module Rules
      class OrderTotalsController < Admin::ApplicationController
        before_action :update_amount, only: %i(create update)

        private

        def update_amount
          API::V1::Support::ConvertToCents.new(params: params, parent_key: :promotion_rules_order_total, child_key: :preferred_amount_min).convert
          API::V1::Support::ConvertToCents.new(params: params, parent_key: :promotion_rules_order_total, child_key: :preferred_amount_max).convert
        end

        def resource_params
          params.require(:promotion_rules_order_total).permit(*permitted_attributes)
        end
      end
    end
  end
end
