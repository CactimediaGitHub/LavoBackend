class Card < ApplicationRecord
  attr_accessor :verification_value

  belongs_to :customer
  has_many :payments

  validates :name, :number, :token, :card_bin,
            :expiry_date, :nick, :customer, presence: true

  # NOTE:make a validation method to log uniqueness errors if needed because of the payfort tokenization callback
  validates :token, uniqueness: { scope: :customer_id }

  def verification_value?
    true
  end
end
