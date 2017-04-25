class Page < ApplicationRecord
  validates :nick, :title, :body, presence: true
  validates :nick, uniqueness: { case_sensitive: false }
end
