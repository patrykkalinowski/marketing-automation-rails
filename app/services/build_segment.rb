class BuildSegment

  def initialize(segment)
    @segment = segment
  end

  def call
    users_to_add = users_meeting_requirements_for(@segment)

    add_users(@segment, users_to_add)
    remove_users(@segment, users_to_add)

    users_to_add
  end

  private

  def remove_users(segment, users_to_add)
    segment.users.where.not(id: users_to_add.uniq).delete_all
  end

  def add_users(segment, users_to_add)
    users_to_add.uniq.each do |user|
      segment.users << User.find(user)
    end
  end

  def users_meeting_requirements_for(segment)
    users = Array.new

    segment.filters.each do |filter|
      users << users_passing_filter(filter)
    end

    users.flatten
  end

  def users_passing_filter(filter)
    users = Array.new

    filter.each do |rule|
      if rule[:name] == "$view"
        find_events_users = BuildSegment::FindEvents.new(rule)
        users << find_events_users.call
      elsif rule[:name] == "$email"
        find_messages_users = BuildSegment::FindMessages.new(rule)
        users << find_messages_users.call
      elsif rule[:name] == "$user"
        find_users = BuildSegment::FindUsers.new(rule)
        users << find_users.call
      elsif rule[:name] == "$segment"
        find_users = BuildSegment::FindSegments.new(rule)
        users << find_users.call
      end
    end

    users_passing_all_rules(users)
  end

  def users_passing_all_rules(users)
    if users.count == 1
      users_to_add = users.flatten
    else
      users.each_with_index { |arr, index|
        if index < users.size-1
          users_to_add = users[index] & users[index+1]
        end
      }
    end

    users_to_add
  end

end
