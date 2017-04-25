class NotificationsMailer < ApplicationMailer

  def account_activation(args={})
    activation_token = args[:activation_token]
    email = args[:email]
    @activation_link = edit_api_activation_url(activation_token, email: email)

    mail(to: email)
  end

  def password_digest(user)
    @reset_link = edit_api_password_reset_url(user.reset_digest)

    mail(to: user.email)
  end

  def password_generated(user, password)
    @password = password
    mail(to: user.email)
  end

  def password_updated(user)
    mail(to: user.email)
  end

  def lavo_order_state_changed(order, recipients)
    @order = order
    emails =
      recipients.map do |user|
        @order.send(user.to_sym).email
      end
    mail(bcc: emails)
  end
end
