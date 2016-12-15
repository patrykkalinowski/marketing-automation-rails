class WorkflowMailer < ApplicationMailer
  default from: 'postmaster@sandbox00ceba3056dd413e95b9fd06a1f51e51.mailgun.org'

  def basic(user)
    @user = user
    
    mail(
      to: @user.email,
      subject: "Testing workflow email"
      )
  end

end
