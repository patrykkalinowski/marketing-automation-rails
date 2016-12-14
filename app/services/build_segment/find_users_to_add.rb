class BuildSegment::FindUsersToAdd

  def initialize(rule)
    @rule = rule
    @rules_hash = {
      "=": ["^s$", "~*"], # matches
      "~": ["s", "~*"], # contains, also accepts regex provided by user
      "^": ["^s", "~*"], # begins with using regex
      "$": ["s$", "~*"], # ends with using regex
      ">": ["s", ">"], # more than x
      "<": ["s", "<"] # less than x
    }

  end

  def call
      if @rule[:name] == "$email"
        find_users_from_messages = BuildSegment::FindUsersFromMessages.new(query)
        found_users = find_users_from_messages.call
      elsif @rule[:name] == "$view"
        find_users_from_events = BuildSegment::FindUsersFromEvents.new(query)
        found_users = find_users_from_events.call
      elsif @rule[:name] == "$user"
        find_users = BuildSegment::FindUsers.new(query)
        found_users = find_users.call
      elsif @rule[:name] == "$segment"
        find_users_from_segments = BuildSegment::FindUsersFromSegments.new(query)
        found_users = find_users_from_segments.call
      elsif @rule[:name] == "$custom" # custom events
        find_users_from_custom_events = BuildSegment::FindUsersFromCustomEvents.new(query)
        found_users = find_users_from_custom_events.call
      end

    found_users
  end

  def query
    if @rule[:match].include?("!") # negative match (ex. !=, !$)
      match = @rule[:match][1..-1] # delete "!" from the beginning
      negative = true
    else
      match = @rule[:match]
      negative = false
    end
      # create wildcard string for database query (ex. "page%")
      pattern = @rules_hash[:"#{match}"].first.gsub(/s/, @rule[:properties].values.first.to_s)
      pattern_match = @rules_hash[:"#{match}"][1]
      key = @rule[:properties].keys.first.to_s

    return {
      key: key,
      pattern: pattern,
      pattern_match: pattern_match,
      negative: negative
    }
  end
end
