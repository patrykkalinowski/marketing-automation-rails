class BuildSegment::FindUsersFromEvents

  def initialize(params)
    # this should prevent SQL injection, but breaks properties->> query (adds " around #{@key})
    # @key = Ahoy::Event.connection.quote_column_name(params[:key])
    @key = params[:key]
    @negative = params[:negative]
    @pattern = params[:pattern]
    @pattern_match = params[:pattern_match]
  end

  def call
    if @negative
      relation = Ahoy::Event.where.not(user_id: nil).where.not("properties->>'#{@key}' #{@pattern_match} ?", @pattern)
      # regex: Ahoy::Event.where("properties->>'title' ~* ?", ".*automation.*")
    else
      relation = Ahoy::Event.where.not(user_id: nil).where("properties->>'#{@key}' #{@pattern_match} ?", @pattern)
    end

    users = Array.new

    relation.each do |event|
      users << event.user_id
    end

    users.uniq
  end

end
