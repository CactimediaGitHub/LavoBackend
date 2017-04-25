class API::V1::User::SocialSigninsController < API::V1::VersionController
  def create
    access_token = token_and_options(request).first

    sign_in = API::User::SocialSignIn.new(token: access_token)

    if sign_in.performed?
      render json: sign_in.user.reload, status: 200, include: :http_token
    else
      render_unauthorized_jsonapi(sign_in)
    end
  end

end