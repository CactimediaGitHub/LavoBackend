require 'active_support/concern'

module API::Concerns::MailerUtils
  extend ActiveSupport::Concern

  def mailer
    @mailer ||= NotificationsMailer
  end

  private

  def send_mail(template, *args)
    mailer.send(template, *args).deliver_later
  end
end
