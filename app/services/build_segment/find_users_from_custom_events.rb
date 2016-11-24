class BuildSegment::FindUsersFromCustomEvents

  def initialize(params)
    @negative = params[:negative]
    @pattern = params[:pattern]
  end

  def call
    if @negative
      relation = Ahoy::Event.where.not(user_id: nil).where.not("name LIKE ?", @pattern)
    else
      relation = Ahoy::Event.where.not(user_id: nil).where("name LIKE ?", @pattern)
    end

    users = Array.new

    relation.each do |event|
      users << event.user_id
    end

    users.uniq
  end

end
