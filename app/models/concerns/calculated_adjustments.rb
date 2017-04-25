module CalculatedAdjustments
  extend ActiveSupport::Concern

  included do
    has_one   :calculator, class_name: 'Calculator', as: :calculable, inverse_of: :calculable, autosave: true
    accepts_nested_attributes_for :calculator
    validates :calculator, presence: true
    delegate :compute, to: :calculator

    def self.calculators
      lavo_calculators.send model_name_without_namespace
    end

    def calculator_type
      calculator.class.to_s if calculator
    end

    def calculator_type=(calculator_type)
      klass = calculator_type.constantize if calculator_type
      self.calculator = klass.new if klass && !self.calculator.is_a?(klass)
    end

    private
    def self.model_name_without_namespace
      self.to_s.tableize.gsub('/', '_')
    end

    def self.lavo_calculators
      Rails.configuration.x.calculators
    end
  end
end