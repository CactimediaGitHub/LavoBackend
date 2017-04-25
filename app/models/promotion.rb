class Promotion < ApplicationRecord
  mount_uploader :icon, IconUploader
  mount_uploader :background_image, BackgroundImageUploader

  has_many :promotion_rules, autosave: true
  alias_method :rules, :promotion_rules
  accepts_nested_attributes_for :promotion_rules, allow_destroy: true

  has_many :promotion_actions, autosave: true
  alias_method :actions, :promotion_actions

  has_many :order_promotions
  has_many :orders, through: :order_promotions

  has_many :vendor_promotions
  has_many :vendors, through: :vendor_promotions

  accepts_nested_attributes_for :promotion_actions, allow_destroy: true

  # FIXME: disable validations for friday seeds
  # validates :name, :promotion_rules, :promotion_actions, presence: true
  validates :name, presence: true
  validates :description, length: { maximum: 255 }, allow_blank: true
  validate :expires_at_must_be_later_than_starts_at, if: -> { starts_at && expires_at }

  def self.active
    where('promotions.starts_at IS NULL OR promotions.starts_at < ?', Time.current).
      where('promotions.expires_at IS NULL OR promotions.expires_at > ?', Time.current)
  end

  def self.active_for_vendor(vendor)
    joins(:vendor_promotions).
    where(vendor_promotions: {vendor_id: vendor&.id}).active
  end

  def eligible?(promotable)
    return false if expired?
    !!eligible_rules(promotable, {})
  end

  def activate(payload)
    order = payload[:order]
    payload[:promotion] = self

    results =
      self.actions.map do |action|
        action.perform(payload)
      end

    # NOTE If an action has been taken, report back to whatever activated this promotion.
    action_taken = results.include?(true)

    if action_taken
    # NOTE connect to the order
    # NOTE create the join_table entry.
      self.orders << order
      self.save
    end

    action_taken
  end

  def line_item_actionable?(order, line_item)
    if eligible? order
      rules = eligible_rules(order)
      if rules.blank?
        true
      else
        rules.send(match_all? ? :all? : :any?) do |rule|
          rule.actionable? line_item
        end
      end
    else
      false
    end
  end


  private

  def expires_at_must_be_later_than_starts_at
    if expires_at < starts_at
      errors.add(:expires_at, :invalid_date_range)
    end
  end

  def expired?
    !!(starts_at && Time.current < starts_at || expires_at && Time.current > expires_at)
  end

  # eligible_rules returns an array of promotion rules where eligible? is true for the promotable
  # if there are no such rules, an empty array is returned
  # if the rules make this promotable ineligible, then nil is returned (i.e. this promotable is not eligible)
  def eligible_rules(promotable, options = {})
    # Promotions without rules are eligible by default.
    return [] if rules.none?
    eligible = lambda { |r| r.eligible?(promotable, options) }
    specific_rules = rules.select { |rule| rule.applicable?(promotable) }
    return [] if specific_rules.none?

    rule_eligibility = Hash[specific_rules.map do |rule|
      # NOTE Checks for appropriate rule preference
      [rule, rule.eligible?(promotable, options)]
    end]
    if match_all?
      # If there are rules for this promotion, but no rules for this
      # particular promotable, then the promotion is ineligible by default.
      unless rule_eligibility.values.all?
        @eligibility_errors = specific_rules.map(&:eligibility_errors).detect(&:present?)
        return nil
      end
      specific_rules
    else
      unless rule_eligibility.values.any?
        @eligibility_errors = specific_rules.map(&:eligibility_errors).detect(&:present?)
        return nil
      end

      [rule_eligibility.detect { |_, eligibility| eligibility }.first]
    end
  end

  def match_all?
    match_policy == 'all'
  end

end
