class API::V1::Pushes::NotificationRegistrationsController < API::V1::VersionController

  before_action :authenticate, only: :create

  def create
    registration =
      current_user.notification_registrations.
      find_or_initialize_by(registration_attributes)

    Rails.logger.tagged("Push notification registration") do
      Rails.logger.info(registration_attributes.inspect)
      Rails.logger.info('--------------')
      Rails.logger.info(registration.inspect)
      Rails.logger.info('--------------')
      Rails.logger.info(registration.valid?)
      Rails.logger.info('--------------')
      Rails.logger.info(registration.errors.inspect)
    end

    if registration.save
      render json: registration, status: :created
    else
      render json: registration,
           status: :unprocessable_entity,
       serializer: ActiveModel::Serializer::ErrorSerializer

    end
  end

  def destroy
    # registration = NotificationRegistration.find_by(token: params[:id])
    # registration&.destroy
  end

  private

  def registration_params
    params.fetch(:data, {}).permit(:type, {
      attributes: %i(token notify)
    })
  end

  def registration_attributes
    registration_params.fetch(:attributes, {})
  end
end
