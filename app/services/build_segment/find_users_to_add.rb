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
        found_users = from_messages(query)
      elsif @rule[:name] == "$view"
        found_users = from_events(query)
      elsif @rule[:name] == "$user"
        found_users = from_users(query)
      elsif @rule[:name] == "$segment"
        found_users = from_segments(query)
      elsif @rule[:name] == "$custom" # custom events
        found_users = from_custom_events(query)
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

  def user_ids(relation)
    users = Array.new

    relation.each do |event|
      users << event.user_id
    end

    users.uniq
  end

  def from_events(query)
    if query[:negative]
      relation = Ahoy::Event.where.not(user_id: nil).where.not("properties->>'#{query[:key]}' #{query[:pattern_match]} ?", query[:pattern])
      # regex: Ahoy::Event.where("properties->>'title' ~* ?", ".*automation.*")
    else
      relation = Ahoy::Event.where.not(user_id: nil).where("properties->>'#{query[:key]}' #{query[:pattern_match]} ?", query[:pattern])
    end

    user_ids(relation)
  end

  def from_custom_events(query)
    if query[:negative]
      relation = Ahoy::Event.where.not(user_id: nil).where.not("name #{query[:pattern_match]} ?", query[:pattern])
    else
      relation = Ahoy::Event.where.not(user_id: nil).where("name #{query[:pattern_match]} ?", query[:pattern])
    end

    user_ids(relation)
  end

  def from_messages(query)
    if query[:negative]
      relation = Ahoy::Message.find_users_not(query)
    else
      relation = Ahoy::Message.find_users(query)
    end

    user_ids(relation)
  end

  def from_segments(query)
    if query[:negative]
      relation = Segment.where.not(id: query[:pattern])
    else
      relation = Segment.find(query[:pattern])
    end

    users = Array.new

    relation.each do |segment|
      users << segment.users
    end

    users.uniq
  end

  def from_users(query)
    sql_query = ActiveRecord::Base::sanitize("#{query[:key]} #{query[:pattern_match]} ?")
    if query[:negative]
      users = User.where.not(sql_query, query[:pattern])
    else
      users = User.where(sql_query, query[:pattern])
    end

    users.uniq
  end

end
