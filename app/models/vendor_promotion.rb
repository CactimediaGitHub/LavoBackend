class VendorPromotion < ApplicationRecord
  belongs_to :vendor
  belongs_to :promotion_rule
end
