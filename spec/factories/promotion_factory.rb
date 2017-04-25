FactoryGirl.define do
  factory :active_promotion, class: Promotion do
    sequence :name do |n|
      "Active promotion - #{n}"
    end
    starts_at { Time.current }
    expires_at { Time.current + 1.day }
    match_policy 'all'
  end

  factory :promotion_with_item_quantity_flat_percent_discount_on_order_total, parent: :active_promotion do |p|
    after(:create) do |promotion, e|
      create(:promotion_rule_order_item_quantity, promotion: promotion)
      create(:promotion_action_create_flat_percent_adjustment, promotion: promotion)
    end
  end

  factory :promotion_with_item_quantity_flat_rate_discount_on_order_total, parent: :active_promotion do |p|
    after(:create) do |promotion, e|
      create(:promotion_rule_order_item_quantity, promotion: promotion)
      create(:promotion_action_create_flat_rate_adjustment, promotion: promotion)
    end
  end

  factory :order_total_flat_percent_on_order_item_total, parent: :active_promotion do |p|
    after(:create) do |promotion, e|
      create(:order_total_promotion_rule, promotion: promotion)
      rule = create(:promotion_rule_order_item, promotion: promotion)
      create(:promotion_action_create_flat_percent_item_adjustment, promotion: promotion)
      promotion.vendors << InventoryItem.find_by(service_id: rule.preferred_service_id, item_id: rule.preferred_item_id, item_type_id: rule.preferred_item_type_id).vendor
    end
  end

  factory :promotion_with_order_total_flat_percent_on_order_total, parent: :active_promotion do |p|
    after(:create) do |promotion, e|
      create(:order_total_promotion_rule, promotion: promotion)
      create(:promotion_action_create_flat_percent_adjustment, promotion: promotion)
    end
  end

  factory :order_total_flat_rate_on_order_item_total, parent: :active_promotion do |p|
    after(:create) do |promotion, e|
      create(:order_total_promotion_rule, promotion: promotion)
      rule = create(:promotion_rule_order_item, promotion: promotion)
      create(:promotion_action_create_flat_rate_item_adjustment, promotion: promotion)
      promotion.vendors << InventoryItem.find_by(service_id: rule.preferred_service_id, item_id: rule.preferred_item_id, item_type_id: rule.preferred_item_type_id).vendor
    end
  end

  factory :promotion_with_order_total_flat_rate_on_order_total, parent: :active_promotion do |p|
    after(:create) do |promotion, e|
      create(:order_total_promotion_rule, promotion: promotion)
      create(:promotion_action_create_flat_rate_adjustment, promotion: promotion)
    end
  end

end
