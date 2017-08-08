class API::V1::Vendor::SearchController < API::V1::VersionController

  def index
    vendors = Vendor.search_by_name(Vendor.activated, params[:query])
    	.activated
    	.select_with_distance(near_vendors_params[:lat], near_vendors_params[:lon])
    
    serialized_vendors_json = ActiveModelSerializers::SerializableResource.new(vendors).as_json
    
    vendors_json = Vendor.stuff_distance(vendors, serialized_vendors_json)
    
    render json: vendors_json
  end

  private

  def near_vendors_params
    params.permit(:lat, :lon)
  end
end