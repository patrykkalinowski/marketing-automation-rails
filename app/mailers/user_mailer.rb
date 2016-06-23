class UserMailer < ApplicationMailer
  default from: 'postmaster@sandbox00ceba3056dd413e95b9fd06a1f51e51.mailgun.org'

  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to My Awesome Site')
  end
end
