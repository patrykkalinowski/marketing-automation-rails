class BuildSegment::FindUsersToAdd

  def initialize(rule)
    @rule = rule
    @rules_hash = {
      "=": "s",
      "^": "s%",
      "~": "%s%",
      "$": "%s",
      "empty": ""
    }

  end

  def call
      if @rule[:name] == "$email"
        messages = BuildSegment::FindUsersFromMessages.new(query)
        found_users = messages.call
      elsif @rule[:name] == "$view"
        events = BuildSegment::FindUsersFromEvents.new(query)
        found_users = events.call
      elsif @rule[:name] == "$user"
        users = BuildSegment::FindUsers.new(query)
        found_users = users.call
      elsif @rule[:name] == "$segment"
        segments = BuildSegment::FindUsersFromSegments.new(query)
        found_users = segments.call
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
      pattern = @rules_hash[:"#{match}"].gsub(/s/, @rule[:properties].values.first.to_s)
      key = @rule[:properties].keys.first.to_s

    return {
      key: key,
      pattern: pattern
      negative: negative
    }
end
