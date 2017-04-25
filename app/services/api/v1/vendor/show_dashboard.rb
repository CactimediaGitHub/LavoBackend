class API::V1::Vendor::ShowDashboard
  include ActiveModel::Model
  include ActiveModel::Serialization

  attr_accessor :vendor
  attr_reader :order_count, :review_count

  def order_count
    @order_count ||= vendor.orders.in_state(:pending).count
  end

  def review_count
    @review_count ||=
      vendor.reviews.reject do |r|
        r.comments.exists?(reviewer_type: Vendor)
      end.size
  end

end
