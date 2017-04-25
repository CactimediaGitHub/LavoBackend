class API::Geocoding::ShowNearVendorsPolygon
  include ActiveModel::Model

  attr_accessor :ne, :nw, :se, :sw, :result

  validates :ne, :nw, :se, :sw, presence: true

  def performed?
    valid? && lookup_result
  end

  private

  def lookup_result
    self.result = Vendor.activated.withing(ne: ne, nw: nw, se: se, sw: sw)
  end

end