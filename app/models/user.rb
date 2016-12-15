class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :visits
  has_and_belongs_to_many :segments
  has_and_belongs_to_many :workflows

  # display name if known, else use e-mail address
  def identity
    if self.first_name || self.last_name
      "#{self.first_name} #{self.last_name}"
    else
      self.email
    end
  end

  def self.find_users(query)
    sql_query = ActiveRecord::Base::sanitize("#{query[:key]} #{query[:pattern_match]} ?")
    self.where(sql_query, query[:pattern])
  end

  def self.find_users_not(query)
    sql_query = ActiveRecord::Base::sanitize("#{query[:key]} #{query[:pattern_match]} ?")
    self.where.not(sql_query, query[:pattern])
  end

  def prepare_timeline
    timeline = Array.new
    # combine all events and messages to one array
    timeline = messages + events
    # sort all events in timeline by time descending
    sorted_timeline = timeline.sort_by { |key| key['time'] }.reverse
  end

  def events
    events = Ahoy::Event.where(user_id: self)

    events_array = Array.new
    events.each do |event|
      # TODO: extract and save info
      events_array << {
        action: "viewed page",
        title: event.properties['title'],
        url: event.properties['url'],
        time: event.time
        }
    end

    events_array
  end

  def messages
    messages = Ahoy::Message.where(user_id: self)

    messages_array = Array.new

    messages.each do |message|
      messages_array << {
        action: "was sent message",
        title: message.subject,
        url: "http://localhost:3000/messages/#{message.message_id}",
        time: message.sent_at
      }

      if message.opened_at
        messages_array << {
          action: "opened message",
          title: message.subject,
          url: nil,
          time: message.opened_at
        }
      end

      if message.clicked_at
        messages_array << {
          action: "clicked message",
          title: message.subject,
          url: nil,
          time: message.clicked_at
        }
      end
    end

    messages_array
  end
end
