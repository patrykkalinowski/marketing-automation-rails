class Segment < ActiveRecord::Base
  serialize :filters
  has_and_belongs_to_many :users


  def self.example
    # segment has many filters
    # filters have many rules
    # rules have many hashes of parameters (type, url, title etc)
    # serialize filters

    # example filter for "visited /messages AND /homepage OR /home/visits"
    filter = [
      [
        { name: "$view",
          properties: {
            page: '/messages',
          }
        }, # AND
        { name: "$view",
          properties: {
            page: '/',
          }
        }
      ], # OR
      [
        { name: "$view",
          properties: {
            page: '/home/visits',
          }
        }
      ]
    ]

    seg = Segment.find 1
    seg.filters = filter
    seg.save
  end

  def self.update
    seg = Segment.find 1
    users_to_add = Array.new
    events = Ahoy::Event.all

    seg.filters.each do |filter|
      # if all conditions true, add user to segment
      conditions = Array.new
      filter.each do |rule|
        puts "Events meeting rule #{rule}: ".green
        events.each do |event|
          # event_properties = Ahoy::Event.find(10).properties.symbolize_keys
          # rule_properties = Segment.find(1).filters[1].first[:properties]
          # event_properties.merge(rule_properties) == event_properties
          if event.name == rule[:name] && event.properties.symbolize_keys.merge(rule[:properties]) == event.properties.symbolize_keys
            puts "Meets rules. #{event.name} #{event.properties}"
          else
            puts "NOT! #{event.name} #{event.properties}"
          end
        end
      end
    end


  end

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
