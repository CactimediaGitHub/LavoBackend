class PageSerializer < ActiveModel::Serializer
  attributes %i(nick title body updated_at)
end
