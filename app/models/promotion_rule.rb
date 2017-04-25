class PromotionRule < ApplicationRecord
  attr_reader :basic_info

  belongs_to :promotion, inverse_of: :promotion_rules

  validates :type, presence: true
  validate :unique_per_promotion, on: :create

  validates :promotion, presence: true

  scope :of_type, ->(t) { where(type: t) }

  def applicable?(promotable)
    raise 'applicable? should be implemented in a sub-class of PromotionRule'
  end

  def eligible?(promotable, options = {})
    raise 'eligible? should be implemented in a sub-class of PromotionRule'
  end

  def eligibility_errors
    @eligibility_errors ||= ActiveModel::Errors.new(self)
  end

  def basic_info
    @basic_info ||= preferences
    # @basic_info ||=
    #   response = []
    #   values = self.preferences.values
    #   binding.pry
    #   Hash[*values].each_pair do |word, decimal|
    #     response << I18n.t(word) << decimal.to_f
    #   end
    #   response.join(" ")
  end

  #TODO

  # This states if a promotion can be applied to the specified line item
  # It is true by default, but can be overridden by promotion rules to provide conditions
  def actionable?(line_item)
    true
  end

  private
  def unique_per_promotion
    if PromotionRule.exists?(promotion_id: promotion_id, type: self.class.name)
      errors.add(:base, :promotion_contains_this_rule_type)
    end
  end

  def eligibility_error_message(key, options = {})
    I18n.t(key, Hash[scope: [:eligibility_errors, :messages]].merge(options))
  end
end
