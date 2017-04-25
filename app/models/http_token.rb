class HttpToken < ApplicationRecord
  belongs_to :tokenable, polymorphic: true

  def self.login_procedure
    Proc.new do |key, options|
      token = find_by(key: key)
      token&.tokenable
    end
  end
end
