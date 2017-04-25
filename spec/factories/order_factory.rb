FactoryGirl.define do
  # ::Order.new(state: :new,
  #             vendor: vendor,
  #             customer: customer,
  #             order_items: order_items.map { |i| OrderItem.new(i) },
  #             shipping: Shipping.new(shipping.merge(state: :new)),
  #             total: total)

  factory :order do
    vendor { create(:vendor) }
    customer { create(:customer) }
    after(:build) do |o|
      o.order_items =
        [
          build(:order_item,
                 order: o,
                 inventory_item: create(:inventory_item_full, vendor: o.vendor))
        ]

      o.shipping =
        build(:shipping,
               order: o,
               shipping_method: (ShippingMethod.all.sample || create(:shipping_method_express, vendor: o.vendor)),
               address: create(:shipping_address))

      o.total =
        API::Order::CartCalculator.new(
          order_items: [ { inventory_item_id: o.order_items.first.inventory_item_id, quantity: o.order_items.first.quantity }],
          shipping: { shipping_method_id: o.shipping.shipping_method_id }
        ).total
    end
  end

  factory :paid_order, class: Order do
    vendor { create(:vendor) }
    customer { create(:customer) }
    after(:build) do |o|
      o.order_items =
        [
          build(:order_item,
                 order: o,
                 inventory_item: create(:inventory_item_full, vendor: o.vendor))
        ]

      o.shipping =
        build(:shipping,
               order: o,
               shipping_method: (ShippingMethod.all.sample || create(:shipping_method_express, vendor: o.vendor)),
               address: create(:shipping_address))

      o.total =
        API::Order::CartCalculator.new(
          order_items: [ { inventory_item_id: o.order_items.first.inventory_item_id, quantity: o.order_items.first.quantity }],
          shipping: { shipping_method_id: o.shipping.shipping_method_id }
        ).total

      o.payment = build(:payment,
                        paid_amount: o.total,
                     credits_amount: 0,
                        order_total: o.total,
                             vendor: o.vendor,
                           customer: o.customer,
                               card: create(:card, customer: o.customer, token: TokenGenerator.uuid))
    end
    after(:create) do |o|
      o.transition_to_pending
    end
  end

  factory :openbasket_order, class: Order do
    vendor { create(:vendor) }
    customer { create(:customer) }
    openbasket true
    after(:build) do |o|
      o.shipping =
        build(:shipping,
               order: o,
               address: create(:shipping_address))
    end
    after(:create) do |o|
      o.transition_to_pending
    end
  end

end
