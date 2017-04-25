Rails.configuration.x.promotions.rules = []
Rails.configuration.x.promotions.rules << Promotion::Rules::OrderTotal
Rails.configuration.x.promotions.rules << Promotion::Rules::OrderItemQuantity
Rails.configuration.x.promotions.rules << Promotion::Rules::OrderItemDiscount

Rails.configuration.x.promotions.actions = []
Rails.configuration.x.promotions.actions << Promotion::Actions::CreateItemAdjustment
Rails.configuration.x.promotions.actions << Promotion::Actions::CreateAdjustment

Rails.configuration.x.calculators = []
Rails.configuration.x.calculators << Promotion::Calculators::FlatPercent
Rails.configuration.x.calculators << Promotion::Calculators::FlatRate
