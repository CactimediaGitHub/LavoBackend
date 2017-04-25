class API::V1::Geocoding::NearVendorsController < API::V1::VersionController
  wrap_parameters format: [:json]

  def show
    scope_ids = Vendor.activated.near(near_vendors_params).pluck(:id)
    scoped_relation = Vendor.where(id: scope_ids)

    index = ::Index::NearVendorsIndex.new(self)
    vendors = index.vendors(scoped_relation)
    render json: vendors,
           include: :inventory_items
  end

  def map
    vendor_search =
      API::Geocoding::ShowNearVendorsPolygon.new(near_vendors_params)

    if vendor_search.performed?
      render json: vendor_search.result, status: :ok
    else
      render json: vendor_search,
           status: :unprocessable_entity,
       serializer: ActiveModel::Serializer::ErrorSerializer
    end
  end

  private

  def near_vendors_params
    params.permit(:lat, :lon, :ne, :nw, :se, :sw, :sort, :filter)
  end

end
