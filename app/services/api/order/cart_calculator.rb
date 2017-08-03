class API::Order::CartCalculator
  include ActiveModel::Model

  attr_accessor :order_items, :shipping, :vendor_id
  attr_reader :total, :subtotal, :promotion_amount

  def subtotal
    @subtotal ||= find_order_items.reduce(0) { |subtotal, i| subtotal + i.total }
  end

  def shipping_amount
    @shipping_amount ||= shipping_method.shipping_charge
  end

  # NOTE: promotion_amount is negative
  def total
    @total ||= shipping_amount + subtotal + promotion_amount.to_i
  end

  def promotion_amount
    @promotion_amount ||= ::API::Order::PromotionAmountCaclulator.new(order: order).compute
  end

  # def vendor
  #   @vendor ||= InventoryItem.find(order_items.first.with_indifferent_access[:inventory_item_id]).vendor
  # end
  #
  # # NOTE final promotion amount. Is negative.
  # def promotion_amount
  #   promotables = order_items.map do |i|
  #     inventory_item = InventoryItem.find(i.with_indifferent_access[:inventory_item_id])
  #     quantity = i.with_indifferent_access[:quantity]
  #     OrderItem.new(inventory_item: inventory_item, quantity: quantity)
  #   end
  #
  #   cart_calculator = self
  #   @promotion_amount ||=
  #     promotables.each_with_object(Array.new) do |promotable, amount|
  #
  #       promotions.each do |promotion|
  #         binding.pry
  #         next unless promotion.eligible?(promotable)
  #
  #         promotion.rules.each do |rule|
  #           # NOTE Checks appropriate rule for cart (order doesn't exist now)  (for ex: >= x <=)
  #           next unless rule.eligible_cart?(cart_calculator)
  #           next unless rule.actionable?(promotable)
  #
  #           promotion.actions.map do |action|
  #             # TODO: move to method calculator#amount
  #             calc_preference = action.calculator.preferences.keys.first
  #             self.calculator_preference_amount = action.send(calc_preference)
  #
  #             amount << action.compute_amount(promotable)
  #           end
  #         end
  #       end
  #     end.reduce(&:+)
  # end
  #
  #
  # private
  #
  # attr_writer :calculator_preference_amount
  #
  # def promotions
  #   @promotions ||= Promotion.includes(:promotion_rules, :promotion_actions).active.where(promotion_rules: {vendor_id: vendor.id})
  # end

  private

  def find_order_items
    order_items.map do |hash|
      OrderItem.new do |i|
        i.inventory_item = InventoryItem.find(hash.with_indifferent_access[:inventory_item_id])
        i.quantity = hash.with_indifferent_access[:quantity]
      end
    end
  end

  def order
    @order ||= Order.new do |o|
      if o.order_items.present?
        o.order_items = find_order_items
      end
      o.vendor_id = @vendor_id
      o.shipping_amount = shipping_amount
      o.subtotal = subtotal
      o.total = o.shipping_amount + o.subtotal
    end
  end

  def shipping_method
    @shipping_method ||= ShippingMethod.find(shipping.with_indifferent_access[:shipping_method_id])
  end

end
