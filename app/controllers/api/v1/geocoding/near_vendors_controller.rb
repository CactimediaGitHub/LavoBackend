class API::V1::Geocoding::NearVendorsController < API::V1::VersionController
  wrap_parameters format: [:json]

  def show
    vendors = Vendor.activated.near(near_vendors_params)
      .select_with_distance(near_vendors_params[:lat], near_vendors_params[:lon])
    serialized_vendors_json = ActiveModelSerializers::SerializableResource.new(vendors).as_json
    vendors_json = Vendor.stuff_distance(vendors, serialized_vendors_json)
    
    render json: vendors_json
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
    params.permit(:lat, :lon, :ne, :nw, :se, :sw, :sort, filter: [:"inventory_items.service_id" => [], :"inventory_items.item_id" => []])
  end

end
