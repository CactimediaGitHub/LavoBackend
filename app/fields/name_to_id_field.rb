require "administrate/field/base"

class NameToIdField < Administrate::Field::Base
  def to_s
    Vendor.where(id: data).try(:name)
  end

  def selectable_options
    collection
  end

  private
  
    def collection
      @collection ||= options.fetch(:collection, [])
    end
end
