class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :visits

  def identity
    if self.first_name || self.last_name
      "#{self.first_name} #{self.last_name}"
    else
      self.email
    end
  end
end
