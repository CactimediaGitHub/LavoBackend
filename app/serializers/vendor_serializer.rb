class VendorSerializer < ActiveModel::Serializer
  attributes :id,
             :name,
             :full_name,
             :lat,
             :lon,
             :address,
             :email,
             :phone,
             :avatar,
             :images,
             :cached_total_reviews,
             :cached_average_rating,
             :balance


  has_many :reviews
  has_many :inventory_items
  has_one :http_token

  def avatar
    object.avatar&.url
  end
end
