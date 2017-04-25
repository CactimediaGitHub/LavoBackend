class API::V1::InventoryItemsController < API::V1::VersionController
  before_action :authenticate
  before_action :set_vendor, only: %i(index services items item_types)

  def index
    render json: @vendor.inventory_items.includes(:item, :item_type, :service, :vendor)
  end

  def services
    render json: @vendor.services.reorder(:id)
  end

  def items
    render json: @vendor.items.reorder(:id)
  end

  def item_types
    render json: @vendor.item_types.reorder(:id)
  end

  private

  def set_vendor
    @vendor = Vendor.find(params[:vendor_id])
  end

  def inventory_item_params
    params.fetch(:data, {}).permit(:type, {
      attributes: %i(name)
    })
  end

  def inventory_item_attributes
    inventory_item_params[:attributes] || {}
  end
end
