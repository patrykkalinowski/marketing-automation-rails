class Segment < ActiveRecord::Base
  serialize :filters
  has_and_belongs_to_many :users


  def self.example
    # segment has many filters
    # filters have many rules
    # rules have many hashes of parameters (type, url, title etc)
    # serialize filters

    filters = [
      [
        { name: "$view",
          match: "^",
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

    Segment.create(filters: filters)
  end

  def self.check_requirements(event, rule, key, value)
    event_properties = event.properties.symbolize_keys # symbolize keys for hash comparison

    # returns true if rule passed
    if rule[:match] === "#" # exact match
      event_properties[key] == (value)
    elsif rule[:match] === "^" # begins with
      event_properties[key].start_with?(value)
    elsif rule[:match] === "~" # includes
      event_properties[key].include?(value)
    elsif rule[:match] === "$" # starts with
      event_properties[key].end_with?(value)
    elsif rule[:match] === "!=" # does not match
      event_properties[key] != (value)
    elsif rule[:match] === "!^" # does not start with
      !event_properties[key].start_with?(value)
    elsif rule[:match] === "!~" # does not contain
      !event_properties[key].include?(value)
    elsif rule[:match] === "!$" # does not end with
      !event_properties[key].end_with?(value)
    else
      # return false if rule not found
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
      # if contact is eligible to join segment, this will change to true
      passed_at_least_one_filter = false
      # user ids to add to this segment
      users_to_add = Array.new

      # iterate over all Ahoy events
      events.each do |event|
        # iterate over all filters and rules of current segment in loop
        segment.filters.each do |filter|
          filter.each do |rule|
              # contains only "true" if set of rules in current filter passed (which means current event passed current filter)
              passed_rules = Array.new

              # iterate over each rule in current's loop filter
              rule[:properties].each { |key, value|
                if Segment.check_requirements(event, rule, key, value)
                  # rule property passed
                  passed_rules << true
                else
                  # rule did not pass (and filter did not pass)
                  passed_rules << false
                end
              }

              unless passed_rules.include?(false)
                # if all rules passed, filter passed and contact meets requirements to be added to segment
                passed_at_least_one_filter = true
              end
          end
        end

        if passed_at_least_one_filter
          # user attached to current event meets segment requirements and will be added to current's loop segment
          users_to_add << event.user_id
        end

      end

      segment.add_remove_users(users_to_add)
    end
  end

  # add users to segment from users_to_add array, remove not included from segment
  def add_remove_users(users_to_add)
    users_to_add.uniq.each do |id|
      unless self.users.exists?(id)
        # add user to segment only if not in segment yet
        puts "adding user #{id} to segment #{self.id}".green
        self.users << User.find(id)
      else
        puts "user #{id} exists in segment #{self.id}, not adding".yellow
      end
    end

    # remove users which are not present in users_to_add array, which means they don't meet requirements
    puts "deleting users from segment #{self.id}".red
    self.users.where.not(id: users_to_add.uniq).delete_all
  end



end
