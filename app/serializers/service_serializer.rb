class ServiceSerializer < ActiveModel::Serializer
  attributes :id, :name

  has_many :items, if: :items_loaded?

  def items_loaded?
    object.items.loaded?
  end
end