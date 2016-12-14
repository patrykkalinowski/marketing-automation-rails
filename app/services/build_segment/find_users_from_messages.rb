class BuildSegment::FindUsersFromMessages

  def initialize(params)
    @key = Ahoy::Message.connection.quote_column_name(params[:key])
    @negative = params[:negative]
    @pattern = params[:pattern]
    @pattern_match = params[:pattern_match]
  end

  def call
    if @negative
      relation = Ahoy::Message.find_users_not(key: @key, pattern: @pattern, pattern_match: @pattern_match)
    else
      relation = Ahoy::Message.find_users(key: @key, pattern: @pattern, pattern_match: @pattern_match)
    end

    users = Array.new

    relation.each do |message|
      users << message.user_id
    end

    users.uniq
  end
end
