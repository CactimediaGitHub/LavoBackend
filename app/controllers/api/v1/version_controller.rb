module API
  module V1
    class VersionController < ApplicationController
      abstract!

      # ember style pagination serialization
      def pagination(object)
        {
          current_page: object.current_page,
          next_page: object.next_page,
          prev_page: object.prev_page,
          total_pages: object.total_pages,
          total_count: object.total_count
        }
      end

      def orders_by_states_count(user)
        {
          new_orders_count: user.new_orders.count,
          active_orders_count: user.active_orders.count,
          history_orders_count: user.history_orders.count
        }
      end

    end
  end
end