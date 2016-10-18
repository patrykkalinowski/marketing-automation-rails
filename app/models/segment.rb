class Segment < ActiveRecord::Base
  serialize :rules
  has_and_belongs_to_many :users

  def update
    type = self.rules[:rule][:type]
    # events = Ahoy::Event.all
    #
    # events.each do |event|
    #   if event.name == type
    #     self.users << event.user_id
    #   end
    # end

    event = Ahoy::Event.find(3)

    if event.name == type
      self.users << User.find(event.user_id)
    end
  end

  def type
    type = self.rules[:rule][:type]
  end
end
