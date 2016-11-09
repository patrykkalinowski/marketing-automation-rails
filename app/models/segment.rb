class Segment < ActiveRecord::Base
  serialize :filters
  has_and_belongs_to_many :users

  def update
    events = Ahoy::Event.where.not(user_id: nil)
    users = User.all
    emails = Ahoy::Message.all

    users_to_add = self.iterate_over(events, emails, users)

    self.add_remove_users(users_to_add)
  end

  def self.check_requirements(event, rule, key, value)
    # if rule is for events, event data is in properties
    if rule[:name] == "$event"
      event = event.properties.symbolize_keys

    # returns true if rule passed
    if rule[:match] === "#" # exact match
      event[key].downcase == (value.downcase)
    elsif rule[:match] === "^" # begins with
      event[key].downcase.start_with?(value.downcase)
    elsif rule[:match] === "~" # includes
      event[key].downcase.include?(value.downcase)
    elsif rule[:match] === "$" # starts with
      event[key].downcase.end_with?(value.downcase)
    elsif rule[:match] === "!=" # does not match
      event[key].downcase != (value.downcase)
    elsif rule[:match] === "!^" # does not start with
      !event[key].downcase.start_with?(value.downcase)
    elsif rule[:match] === "!~" # does not contain
      !event[key].downcase.include?(value.downcase)
    elsif rule[:match] === "!$" # does not end with
      !event[key].downcase.end_with?(value.downcase)
    elsif rule[:match] === "empty" # is empty
      event[key].empty?
    elsif rule[:match] === "!empty" # is not empty
      !event[key].empty?
    else
      # return false if rule not found
      # TODO: log error
      return false
    end
  end

  def self.update_all_emails
    emails = Ahoy::Message.where.not(user_id: nil)
    segments = Segment.all

    segments.each do |segment|
      # user ids to add to this segment
      users_to_add = segment.iterate_over_emails(emails)

      segment.add_remove_users(users_to_add)
    end
  end



  def self.update_all_events
    # update all segments based on all events
    events = Ahoy::Event.where.not(user_id: nil)
    segments = Segment.all

    segments.each do |segment|
      # user ids to add to this segment
      users_to_add = segment.iterate_over(events)

      segment.add_remove_users(users_to_add)
    end
  end

  # add users to segment from users_to_add array, remove not included from segment
  def add_remove_users(users_to_add)
    users_to_add.uniq.each do |id|
      unless self.users.exists?(id)
        user = User.find_by_id(id)
        if user
          # add user to segment only if not in segment yet
          puts "adding user #{id} to segment #{self.id}".green
          self.users << User.find_by_id(id)
        else
          puts "user #{id} not found".yellow
        end
      else
        puts "user #{id} exists in segment #{self.id}, not adding".yellow
      end
    end

    # remove users which are not present in users_to_add array, which means they don't meet requirements
    puts "deleting users from segment #{self.id}".red
    self.users.where.not(id: users_to_add.uniq).delete_all
  end

  def iterate_over_events(events)
    users_to_add = Array.new

    # iterate over all filters and rules of current segment in loop
    self.filters.each do |filter|

      # [ [ rule1_user_ids ], [ rule2_user_ids ], [ ruleN_user_ids ]]
      # user_id must be present in every rule subarray to pass filter
      all_rules_user_ids = Array.new

      filter.each do |rule|
        # iterate over each rule in current's loop filter
        rule[:properties].each { |key, value|
          rule_user_ids = Array.new

          events.each do |event|
            if Segment.check_requirements(event, rule, key, value)
              # save user_id from event passing rule
              rule_user_ids << event.user_id
            end
          end

          # [ [ rule1_user_ids ], [ rule2_user_ids ], [ ruleN_user_ids ]]
          all_rules_user_ids << rule_user_ids.uniq
        }
      end

      users_to_add += Segment.users_passing_filter(all_rules_user_ids)
    end

    users_to_add
  end

  def iterate_over_emails(emails)
    users_to_add = Array.new

    # iterate over all filters and rules of current segment in loop
    self.filters.each do |filter|

      # [ [ rule1_user_ids ], [ rule2_user_ids ], [ ruleN_user_ids ]]
      # user_id must be present in every rule subarray to pass filter
      all_rules_user_ids = Array.new

      filter.each do |rule|
        # iterate over each rule in current's loop filter
        rule[:properties].each { |key, value|
          rule_user_ids = Array.new

          emails.each do |email|
            if Segment.check_requirements_emails(email, rule, key, value)
              # save user_id from event passing rule
              rule_user_ids << email.user_id
            end
          end

          # [ [ rule1_user_ids ], [ rule2_user_ids ], [ ruleN_user_ids ]]
          all_rules_user_ids << rule_user_ids.uniq
        }
      end

      users_to_add += Segment.users_passing_filter(all_rules_user_ids)
    end

    users_to_add
  end

  def iterate_over(events, emails, users)
    users_to_add = Array.new

    # iterate over all filters and rules of current segment in loop
    self.filters.each do |filter|

      # [ [ rule1_user_ids ], [ rule2_user_ids ], [ ruleN_user_ids ]]
      # user_id must be present in every rule subarray to pass filter
      all_rules_user_ids = Array.new

      filter.each do |rule|
        # iterate over each rule in current's loop filter
        rule[:properties].each { |key, value|
          rule_user_ids = Array.new

          events.each do |event|
            if Segment.check_requirements(event, rule, key, value)
              # save user_id from event passing rule
              rule_user_ids << event.user_id
            end
          end
          emails.each do |email|
            if Segment.check_requirements_emails(email, rule, key, value)
              # save user_id from event passing rule
              rule_user_ids << email.user_id
            end
          end
          users.each do |user|
            if Segment.check_requirements_emails(user, rule, key, value)
              # save user_id from event passing rule
              rule_user_ids << user.id
            end
          end

          # [ [ rule1_user_ids ], [ rule2_user_ids ], [ ruleN_user_ids ]]
          all_rules_user_ids << rule_user_ids.uniq
        }
      end

      users_to_add += Segment.users_passing_filter(all_rules_user_ids)
    end

    users_to_add
  end

  def self.users_passing_filter(all_rules_user_ids)
    # array of user_ids passing filter
    filter_array = Array.new

    # find user_ids present in all subarrays (meeting all rules)
    all_rules_user_ids.each_with_index { |arr, index|
      if index < all_rules_user_ids.size-1
        filter_array = all_rules_user_ids[index] & all_rules_user_ids[index+1]
      end
    }

    filter_array
  end

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
      ], # OR
      [
        { name: "$email",
          match: "~",
          properties: {
            subject: "Example Message"
          },
        }, # AND
        {
          name: "$email",
          match: "#",
          properties: {
            to: "patryk.kalinowski"
          }
        }
      ]
    ]

    Segment.create(filters: filters)
  end

end
end
