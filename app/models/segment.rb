class Segment < ActiveRecord::Base
  serialize :rules
  has_and_belongs_to_many :users

  def self.time
    # check if event is newer than last segment update
    last_update = Time.zone.now - 14.day

    events = Ahoy::Event.all

    events.each do |event|
      puts event.time
      puts event.time.between?(last_update, Time.zone.now)
      puts "---"
    end
  end

  def self.update_segments
    last_update = Time.zone.now - 300.day
    puts last_update..Time.zone.now
    new_events = Ahoy::Event.where(time: last_update..Time.zone.now)
    # segments = Segment.find 6
    seg = Segment.find 6

    new_events.find_each do |event|
      # segments.find_each do |segment|
        if event.name == seg.rules[:rule][:type] && seg.rules[:rule][:properties][:page] == event.properties['page']
        # self.users << event.user_id
        seg.users << User.find(event.user_id)
      end
    end

  end

  def type
    type = self.rules[:rule][:type]
  end


end
