class API::V1::VendorsController < API::V1::VersionController

  before_action :authenticate, except: %i(create show reviews)
  before_action :set_vendor, only: %i(show reviews shipping_methods schedule)

  def index
  end

  def create
    @vendor = ::Vendor.new(vendor_params)

    if @vendor.save
      render json: @vendor,
             status: :created,
             location: [:api, @vendor]
    else
      render json: @vendor.errors,
             status: :unprocessable_entity
    end
  end

  def update
    if current_user.update(vendor_attributes)
      render json: current_user
    else
      render json: current_user,
             status: :unprocessable_entity,
             serializer: ActiveModel::Serializer::ErrorSerializer
    end
  end

  #TODO: do we need reviews here?
  def show
    render json: @vendor,
           include: :reviews,
           meta: { 'order-count': order_count,
                   'can-review': can_review }
  end

  def reviews
    render json: @vendor.reviews, include: [:reviewer, :comments]
  end

  def shipping_methods
    render json: @vendor.shipping_methods,
           each_serializer: ShippingMethodSerializer
  end

  def schedule
    render json: @vendor.schedules
  end

  private

  def set_vendor
    @vendor = ::Vendor.find(params[:id])
  end

  def vendor_params
    params.fetch(:data, {}).permit(:type, {
      attributes: ::Vendor.permitted_attributes
    })
  end

  def vendor_attributes
    vendor_params[:attributes] || {}
  end

  def meta_params
    params.permit(:customer_id)
  end

  def order_count
    ::Order.in_state(:completed).
            where(customer_id: meta_params[:customer_id], vendor: @vendor).
            count
  end

  def can_review
    review_count =
      @vendor.
        reviews.
        where(reviewer_type: 'Customer', reviewer_id: meta_params[:customer_id]).
        count

    order_count > review_count
  end

end
