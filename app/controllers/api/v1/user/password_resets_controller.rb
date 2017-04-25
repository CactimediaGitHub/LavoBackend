class API::V1::User::PasswordResetsController < API::V1::VersionController
  before_action :authenticate, only: [:update]

  def create
    reset = API::User::ResetPassword.new(reset_params)

    if reset.performed?
      render json: reset.user, status: :ok
    else
      render json: reset.errors, status: :unprocessable_entity
    end
  end

  def edit
    generate = API::User::GenerateTmpPassword.new(reset_digest: params[:id])

    if generate.performed?
      render plain: "A new password has been sent to #{generate.user.email}",
            status: :ok
    else
      render json: generate.errors, status: :unprocessable_entity
    end
  end

  def update
    merged_params = reset_params.merge(email: current_user.email)
    update = API::User::UpdatePassword.new(merged_params)

    if update.performed?
      render json: update.user, status: :ok
    else
      render json: update.errors, status: :unprocessable_entity
    end
  end

  private
    def reset_params
      params.
        require(:password_reset).
        permit(:id, :email, :password, :password_confirmation)
    end
end
