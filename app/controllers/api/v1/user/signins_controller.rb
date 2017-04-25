class API::V1::User::SigninsController < API::V1::VersionController

  def create
    sign_in = API::User::SignIn.new(signin_attributes)

    if sign_in.performed?
      render json: sign_in.user, status: 200, include: :http_token
    else
      render_unauthorized_jsonapi(sign_in.errors_delegator)
    end
  end

  private

  def signin_params
    params.require(:data).
      permit :type, :id, {
        attributes: [:email, :password]
      }
  end

  def signin_attributes
    signin_params[:attributes] || {}
  end

end
