class ScheduleSerializer < ActiveModel::Serializer
  attributes :weekday, :hours

  belongs_to :vendor
end