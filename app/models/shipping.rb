class Shipping < ApplicationRecord
  belongs_to :shipping_method
  belongs_to :order
  # TODO: return to belong_to assosiation if required by shipping dashboard
  has_one    :address, class_name: "ShippingAddress"

  validates :shipping_method, presence: true, unless: -> { order.openbasket }
  validates :order, presence: true
  validates :address, presence: true
  validates :pick_up, :drop_off, presence: true

  def pick_up
  	"#{self[:pick_up].first.strftime('%B %d, %Y')} #{self[:pick_up].first.strftime("%I:%M %p")} - #{self[:pick_up].last.strftime("%I:%M %p")}"
  end

  def drop_off
  	"#{self[:drop_off].first.strftime('%B %d, %Y')} #{self[:drop_off].first.strftime("%I:%M %p")} - #{self[:drop_off].last.strftime("%I:%M %p")}"
  end
end
