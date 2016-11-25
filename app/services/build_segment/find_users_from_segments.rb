class BuildSegment::FindUsersFromSegments

  def initialize(params)
    @negative = params[:negative]
    @pattern = params[:pattern]
  end

  def call
    if @negative
      relation = Segment.where.not("name LIKE ?", @pattern)
    else
      relation = Segment.where("name LIKE ?", @pattern)
    end

    users = Array.new

    relation.each do |segment|
      users << segment.users
    end

    users.uniq
  end
  
end
