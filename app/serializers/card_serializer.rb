class CardSerializer < ActiveModel::Serializer
  attributes :name, :number, :token, :card_bin, :expiry_date, :nick, :first_purchase

  belongs_to :customer

  def first_purchase
    object.payments.count == 0
  end
end