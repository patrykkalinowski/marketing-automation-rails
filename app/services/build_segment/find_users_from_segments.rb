class BuildSegment::FindUsersFromSegments

  def initialize(params)
    @negative = params[:negative]
    @segment_id = params[:pattern]
  end

  def call
    if @negative
      relation = Segment.where.not(id: @segment_id)
    else
      relation = Segment.find(@segment_id)
    end

    users = Array.new

    relation.each do |segment|
      users << segment.users
    end

    users.uniq
  end

end
