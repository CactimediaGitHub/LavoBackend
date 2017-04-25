class CreditCardSerializer < ActiveModel::Serializer
  attributes %i(mask)

  def mask
    ::API::V1::Support::CardUtils.mask(object)
  end
end