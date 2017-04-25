class ShippingSerializer < ActiveModel::Serializer
  attributes %i(pick_up drop_off)

  def pick_up
    @pick_up ||= format_attribute(object.pick_up)
  end

  def drop_off
    @drop_off ||= format_attribute(object.drop_off)
  end


  belongs_to :shipping_method
  belongs_to :order
  has_one :address

  private

  def format_attribute(attr)
    ary = attr.to_s.split('..')
    "[#{ary[0]},#{ary[1]}]"
  end
end
