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
          match: "^", # use different name - maybe match? # - exact match, ~ - contains, $ - ends with, ! - is not (exact match), ^ - begins with, !$ - does not end with, !^ - does not begin with, !~ - does not contain
          properties: {
            page: '/messages',
          }
        }, # AND
        { name: "$view",
          match: "$",
          properties: {
            page: '1',
          }
        }
      ], # OR
      [
        { name: "$view",
          match: "!",
          properties: {
            page: '/messages/1',
          }
        }
      ], # OR
      [
        { name: "$view",
          match: "~",
          properties: {
            url: 'param=test',
          }
        }
      ]
    ]

    seg = Segment.new
    seg.filters = filter
    seg.save
  end

  def self.check_requirements(event, rule, key, value)
    event_properties = event.properties.symbolize_keys
    # returns true if rules are passed
    if rule[:match] === "#"
      event_properties[key] == (value)
    elsif rule[:match] === "^"
      event_properties[key].start_with?(value)
    elsif rule[:match] === "~"
      event_properties[key].include?(value)
    elsif rule[:match] === "$"
      event_properties[key].end_with?(value)
    elsif rule[:match] === "!="
      event_properties[key] != (value)
    elsif rule[:match] === "!$"
      !event_properties[key].end_with?(value)
    elsif rule[:match] === "!^"
      !event_properties[key].start_with?(value)
    elsif rule[:match] === "!~"
      !event_properties[key].include?(value)
    else
      # TODO: log error
      return false
    end
  end

  def self.update_all_emails
    # TODO
  end

  def self.update_all_events
    # update all segments based on all events
    events = Ahoy::Event.where.not(user_id: nil)
    segments = Segment.all



    segments.each do |segment|
      # contains at least one "true" if contact should be added to segment
      # if contains only "false", contact should be removed from segment
      passed_filters = Array.new
      user_filters = Array.new
      users_to_add = Array.new

      # TODO: right now, user is added/removed from segment for each event, which causes hundreds unnecessary database calls
      # find a way to check segment requirements for all scanned events once and use only 1 database call to add/remove from segment

      passed_at_least_one_filter = false
      events.each do |event|

        segment.filters.each do |rules|
          rules.each do |rule|
              # contains only "true" if set of rules has been passed (which means at least whole one filter has been passed)
              passed_rules = Array.new

              rule[:properties].each { |key, value|
                if Segment.check_requirements(event, rule, key, value)
                  # rule property has been passed
                  passed_rules << true
                else
                  passed_rules << false
                end
              }

              unless passed_rules.include?(false)
                # if all rule properties are passed, whole rule has been passed and contact meets requirements to be added to segment
                passed_at_least_one_filter = true
              end
          end
        end

        if passed_at_least_one_filter

          users_to_add << event.user_id
          # segment.users << User.find(event.user_id)
        else
          # segment.users.delete(User.find(event.user_id))
        end

      end
      users_to_add.uniq.each do |id|
        user = User.find id
        unless segment.users.exists?(user.id)
          puts "adding user #{id} to segment #{segment.id}".green
          segment.users << user
        else
          puts "user #{id} exists in segment #{segment.id}, not adding".yellow
        end
      end

      # remove from segment users which are not present in users_to_add array
      puts "deleting users from segment #{segment.id}".red
      segment.users.where.not(id: users_to_add.uniq).delete_all
    end
  end






end
