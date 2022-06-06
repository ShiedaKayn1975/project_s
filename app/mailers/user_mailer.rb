class UserMailer < ApplicationMailer
  def activation user, token
    @user = user
    @token = token

    mail(to: @user.email, subject: "[PECK] Activate your account" )
  end
end
