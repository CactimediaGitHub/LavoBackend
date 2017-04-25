class API::V1::User::SignoutsController < API::V1::VersionController

  before_action :authenticate, only: :destroy
  before_action :set_http_token, only: :destroy

  def destroy
    @http_token.destroy
    head :no_content
  end

  private
    def set_http_token
      key = token_and_options(request).first
      @http_token = HttpToken.find_by(key: key)
    end

end