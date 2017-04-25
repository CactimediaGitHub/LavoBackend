class API::V1::User::ActivationsController < API::V1::VersionController

  def edit
    merged_params = activation_params.merge(token: params[:id])
    activation = API::User::Activate.new(merged_params)

    if activation.performed?
      render plain: "User #{activation.user.email} is activated",
             status: :ok
    else
      render plain: activation.errors.full_messages.join(', '),
             status: :unprocessable_entity
    end
  end

  private
    def activation_params
      params.permit(:email)
    end
end
