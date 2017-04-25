require 'bigdecimal'

FactoryGirl.define do
  factory :order_total_promotion_rule, class: Promotion::Rules::OrderTotal do
    type { Promotion::Rules::OrderTotal }
    preferences { {
      :operator_min => 'gt',
      :operator_max => 'lt',
      :amount_min => 10,
      :amount_max => 100000
      } }
  end
end

FactoryGirl.define do
  factory :promotion_rule_order_item_quantity, class: Promotion::Rules::OrderItemQuantity do
    type { Promotion::Rules::OrderItemQuantity }
    preferences { {
      :order_item_quantity => 2,
    } }
  end
end

FactoryGirl.define do
  factory :promotion_rule_order_item, class: Promotion::Rules::OrderItemDiscount do
    type { Promotion::Rules::OrderItemDiscount }
    preferences do
      vendor = create(:active_vendor)
      inventory_item = vendor.inventory_items.first
      {
          service_id: inventory_item.service_id,
             item_id: inventory_item.item_id,
        item_type_id: inventory_item.item_type_id,
      }
    end
  end
end
