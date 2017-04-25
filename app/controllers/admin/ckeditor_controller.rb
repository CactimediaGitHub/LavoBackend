module Admin
  class CkeditorController < ActionController::Base
    protect_from_forgery unless: -> { request.format.json? }
  end
end