module Admin
  class ReportsController < ApplicationController

    before_action :filter_vendors, only: [:search_vendor_transactions, :export_transactions]

    def vendor_transactions
      @vendors_name = Vendor.pluck(:name, :id)
      @vendors = []
    end

    def search_vendor_transactions
      respond_to do |format|
        format.js
      end
    end

    def export_transactions
      respond_to do |format|
        format.csv { send_data Vendor.to_transactions_csv(@vendors), filename: "transactions-#{Date.today}.csv" }
      end
    end

    private

      def filter_vendors
        vendor_ids = action_name.eql?('export_transactions') ? params[:vendor][:ids][0].split(',') : vendor_ids = params[:vendor][:ids]
        vendor_start_date = params[:vendor][:start_date]
        vendor_end_date = params[:vendor][:end_date]
        @vendors = Vendor.fetch_transaction_report(vendor_ids, vendor_start_date, vendor_end_date)
      end
  end
end
