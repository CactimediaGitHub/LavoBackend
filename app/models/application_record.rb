class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  include Preferences::Preferable
  serialize :preferences, Hash
end
