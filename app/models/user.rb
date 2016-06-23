class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :visits

  # display name if known, else use e-mail address
  def identity
    if self.first_name || self.last_name
      "#{self.first_name} #{self.last_name}"
    else
      self.email
    end
  end

  def send_welcome_email
    # Tell the UserMailer to send a welcome email
    UserMailer.welcome_email(self).deliver_now
  end
end
