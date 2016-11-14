class BuildSegment

  def initialize(segment)
    @segment = segment
  end

  def call
    users_to_add = users_meeting_requirements_for(@segment)

    puts "users to add: #{users_to_add}"
    add_users(@segment, users_to_add)
    remove_users(@segment, users_to_add)
  end

  private

  def remove_users(segment, users_to_add)
    segment.users.where.not(id: users_to_add.uniq).delete_all
  end

  def add_users(segment, users_to_add)
    segment.users << users_to_add.uniq
  end

  def users_meeting_requirements_for(segment)
    users = Array.new

    segment.filters.each do |filter|
      users << users_passing_filter(filter)
    end

    users.flatten.uniq
  end

  def users_passing_filter(filter)
    users = Array.new
    filtered_users = Array.new

    filter.each do |rule|
      users << users_passing_rule(rule)
    end

    # => users = [[rule1_users],[rule2_users]]
    users.each_with_index { |arr, index|
      if index < users.size-1
        filtered_users = users[index] & users[index+1]
      end
    }

    filtered_users
  end

  def users_passing_rule(rule)
    users = Array.new

    if rule[:match] === "#" # exact match
      relation = Ahoy::Event.where_properties(rule[:properties])
    elsif rule[:match] === "^" # begins with
      relation = Ahoy::Event.where.not(user_id: nil).where("properties->>'#{rule[:properties].keys.first.to_s}' LIKE ?", "#{rule[:properties].values.first.to_s}%")
    elsif rule[:match] === "~" # includes
      relation = Ahoy::Event.where.not(user_id: nil).where("properties->>'#{rule[:properties].keys.first.to_s}' LIKE ?", "%#{rule[:properties].values.first.to_s}%")
    elsif rule[:match] === "$" # ends with
      relation = Ahoy::Event.where.not(user_id: nil).where("properties->>'#{rule[:properties].keys.first.to_s}' LIKE ?", "%#{rule[:properties].values.first.to_s}")
    elsif rule[:match] === "!=" # does not match
      relation = Ahoy::Event.where.not(user_id: nil).where.not("properties->>'#{rule[:properties].keys.first.to_s}' = ?", "#{rule[:properties].values.first.to_s}")
    elsif rule[:match] === "!^" # does not start with
      relation = Ahoy::Event.where.not(user_id: nil).where.not("properties->>'#{rule[:properties].keys.first.to_s}' LIKE ?", "#{rule[:properties].values.first.to_s}%")
    elsif rule[:match] === "!~" # does not contain
      relation = Ahoy::Event.where.not(user_id: nil).where.not("properties->>'#{rule[:properties].keys.first.to_s}' LIKE ?", "%#{rule[:properties].values.first.to_s}%")
    elsif rule[:match] === "!$" # does not end with
      relation = Ahoy::Event.where.not(user_id: nil).where.not("properties->>'#{rule[:properties].keys.first.to_s}' LIKE ?", "%#{rule[:properties].values.first.to_s}")
    elsif rule[:match] === "empty" # is empty
      relation = Ahoy::Event.where.not(user_id: nil).where("properties->>'#{rule[:properties].keys.first.to_s}' = ?", "")
    elsif rule[:match] === "!empty" # is not empty
      relation = Ahoy::Event.where.not(user_id: nil).where.not("properties->>'#{rule[:properties].keys.first.to_s}' = ?", "")
    else
      # return false if rule not found
      # TODO: log error
      return false
    end

    relation.each do |event|
      users << event.user_id
    end

    users.uniq
  end
end
