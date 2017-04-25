class PromotionAction < ApplicationRecord
  belongs_to :promotion

  #NOTE: place this attributes here to enable value display in PromotionActionDashboard
  attr_accessor :calculator_amount, :calculator_type

  before_validation :set_calculator

  validates :promotion, presence: true

  # NOTE: calculator.preferred_amount.to_i >= 0 if default calc set
  validates :calculator_amount,
    numericality: { greater_than: 0, only_integer: true },
    unless: -> { calculator.preferred_amount.to_i >= 0 }

  scope :of_type, ->(t) { where(type: t) }

  def perform(options = {})
    raise 'perform should be implemented in a sub-class of PromotionAction'
  end

  # def calculator_type
  #   @calculator_type || Rails.configuration.x.calculators.first
  # end

  private

  def set_calculator
    return if calculator.present? && calculator.preferred_amount > 0
    klass = Object.const_get(calculator_type || Rails.configuration.x.calculators.first.to_s)
    self.calculator = klass.new(preferred_amount: calculator_amount || 0)
  end

end
