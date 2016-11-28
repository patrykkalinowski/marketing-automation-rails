class BuildSegment::FindUsersFromEvents

  def initialize(params)
    # this should prevent SQL injection, but breaks properties->> query (adds " around #{@key})
    # @key = Ahoy::Event.connection.quote_column_name(params[:key])
    @key = params[:key]
    @negative = params[:negative]
    @pattern = params[:pattern]
  end

  def call
    if @negative
      relation = Ahoy::Event.where.not(user_id: nil).where.not("properties->>'#{@key}' LIKE ?", @pattern)
    else
      relation = Ahoy::Event.where.not(user_id: nil).where("properties->>'#{@key}' LIKE ?", @pattern)
    end

    users = Array.new

    relation.each do |event|
      users << event.user_id
    end

    users.uniq
  end

end
