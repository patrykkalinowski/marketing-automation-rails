class BuildSegment

  def call
    segment = params[:segment]
    users_to_add = users_meeting_requirements_for(segment)

    add_users(segment, users_to_add)
    remove_users(segment, users_to_add)
  end

  private

  def remove_users(segment, users_to_add)
    segment.users.where.not(id: users_to_add.uniq).delete_all
  end

  def add_users(segment, users_to_add)
    segment.users << users_to_add
  end

  def users_meeting_requirements_for(segment)
    users = Array.new

    segment.filters.each do |filter|
      users << users_passing_filter(filter)
    end

    users
  end

  def users_passing_filter(filter)
    users = Array.new

    filter.each do |rule|

    end
  end

  def users_passing_rule(rule)

  end


  def find_rules
    user_rules = Array.new

    rules.each do |rule|
      users_rules << users_meeting_rule(rule)
    end

    user_rules.uniq
  end

  def users_meeting_rule

  end
end
