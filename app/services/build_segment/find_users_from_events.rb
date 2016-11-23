class BuildSegment::FindUsersFromEvents

  def initialize(params)
    @key = params[:key]
    @negative = params[:negative]
    @pattern = params[:pattern]
  end

  def call
    if @negative
      relation = Ahoy::Event.where.not(user_id: nil).where.not("#{key} LIKE ?", pattern)
    else
      relation = Ahoy::Event.where.not(user_id: nil).where("#{key} LIKE ?", pattern)
    end

    users = Array.new

    relation.each do |event|
      users << event.user_id
    end

    users.uniq
  end

end
