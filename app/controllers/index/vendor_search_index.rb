module Index
  class VendorSearchIndex < BaseIndex

    def vendors(scope = Vendor)
      @orders ||= prepare_records(scope)
    end
  end
end