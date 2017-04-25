# Preview all emails at http://localhost:3000/rails/mailers/notifications_mailer
class NotificationsMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/notifications_mailer/password_digest
  def password_digest
    NotificationsMailer.password_digest
  end

  # Preview this email at http://localhost:3000/rails/mailers/notifications_mailer/password_generated
  def password_generated
    NotificationsMailer.password_generated
  end

end
