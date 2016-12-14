class BuildSegment::FindUsersFromMessages

  def initialize(params)
    @key = Ahoy::Message.connection.quote_column_name(params[:key])
    @negative = params[:negative]
    @pattern = params[:pattern]
  end

  def call
    if @negative
      relation = Ahoy::Message.find_users_not(key: @key, pattern: @pattern)
    else
      relation = Ahoy::Message.find_users(key: @key, pattern: @pattern)
    end

    users = Array.new

    relation.each do |message|
      users << message.user_id
    end

    users.uniq
  end
end
