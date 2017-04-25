class API::V1::Vendor::ShowDashboardSerializer < ActiveModel::Serializer
  attributes %i(order_count review_count)

  def id
    1
  end

end
