require 'active_support/concern'

module Authenticatable
  extend ActiveSupport::Concern

  attr_reader :current_user

  protected

  def authenticate
    # FIXME: new authorization solution needed
    authenticate_token || render_unauthorized
  end

  def authenticate_token
    @current_user ||= authenticate_with_http_token(&HttpToken.login_procedure)
  end

  def render_unauthorized(errors={ error: I18n.t(:bad_credentials) })
    self.headers['WWW-Authenticate'] = 'Token realm="Application"'
    render json: errors, status: 401
  end

  # TODO: replace render_unauthorized with this meth
  def render_unauthorized_jsonapi(resource)
    self.headers['WWW-Authenticate'] = 'Token realm="Application"'
    render json: resource, status: 401, serializer: ActiveModel::Serializer::ErrorSerializer
  end

  def token_and_options(request)
    ActionController::HttpAuthentication::Token.token_and_options(request)
  end

end