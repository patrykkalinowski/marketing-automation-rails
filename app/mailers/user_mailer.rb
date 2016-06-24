class UserMailer < ApplicationMailer
  default from: 'postmaster@sandbox00ceba3056dd413e95b9fd06a1f51e51.mailgun.org'

  def basic_email(recipient, message)
    @recipient = recipient
    @message = message
    track extra: { message_id: message.id }
    mail(
      from: %("#{message.from_name}" <#{message.from_email}>),
      to: recipient.email,
      subject: message.subject
      )
  end
end
