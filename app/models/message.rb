class Message < ActiveRecord::Base

  def send_email(recipient)
    UserMailer.basic_email(recipient, self).deliver_now
  end
end
