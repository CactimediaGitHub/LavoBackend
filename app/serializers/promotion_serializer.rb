class PromotionSerializer < ActiveModel::Serializer
  attributes %i(name icon background_image_url description starts_at expires_at)
  has_many :promotion_rules
  has_many :promotion_actions

  def background_image_url
  	object.background_image.file.nil? ? " " : object.background_image.url
  end
end
