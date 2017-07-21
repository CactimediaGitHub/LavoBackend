module Admin
  class UploadsController < ApplicationController
    include BulkUploader

    def index
      @upload_types = ['Vendors', 'Inventory Items', 'Schedules', 'Items']
    end

    def vendor_details
      @alert_msg = ''
      if params[:upload][:type].present? && params[:upload][:file].present?
        @has_errors, @error_msgs = 
            BulkUploader.upload(params[:upload][:file], params[:upload][:type])
      else
        @alert_msg += 'Upload type or file is not selected.'
      end
    end
  end
end
