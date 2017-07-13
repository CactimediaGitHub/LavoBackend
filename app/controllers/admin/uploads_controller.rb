module Admin
  class UploadsController < ApplicationController
    include BulkUploader

    def index
      @upload_types = ['Vendors', 'Inventory Items', 'Schedules', 'Items']
      @vendors_name = Vendor.pluck(:name, :id)
      @item_types_name = ItemType.pluck(:name, :id)
      @items_name = Item.pluck(:name, :id)
      @services_name = Service.pluck(:name, :id)
    end

    def vendor_details
      vendor_id = params[:upload][:vendor_id].strip
      service_id = params[:upload][:service_id].strip
      item_id = params[:upload][:item_id].strip
      item_type_id = params[:upload][:item_type_id].strip
      @alert_msg = ''
      if params[:upload][:type].present? && params[:upload][:file].present?
        if params[:upload][:type].strip.eql?('Inventory Items') && 
          (vendor_id.blank? || service_id.blank? || item_id.blank? || 
           item_type_id.blank?)
          @alert_msg += 'Vendor or service or item or item type is not selected.'
        elsif params[:upload][:type].strip.eql?('Schedules') && vendor_id.blank?
          @alert_msg += 'Vendor is not selected.'
        else
          @has_errors, @error_msgs = 
            BulkUploader.upload(params[:upload][:file], params[:upload][:type], 
                                vendor_id, service_id, item_id, item_type_id)
        end
      else
        @alert_msg += 'Upload type or file is not selected.'
      end
    end
  end
end
