class CustomerSerializer < ActiveModel::Serializer
  attributes %i(id name surname full_name email phone avatar activated credits_amount prefix_phone)

  has_one :http_token
  has_many :addresses
  has_many :reviews
  has_many :orders

  def avatar
    object.avatar.url
  end
end