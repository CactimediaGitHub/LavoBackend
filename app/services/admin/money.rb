class Admin::Money
  attr_accessor :money

  def self.to_cents(amount)
    (amount.to_i.to_d*100).to_i
  rescue TypeError
    0
  end

  def initialize(amount)
    @money = Money.new(amount.to_i)
  end

  def format(options={})
    money.format(options={})
  end

  def symbol
    money.symbol
  end
end
