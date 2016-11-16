class BuildSegment::FindSegments

  def initialize(rule)
    @rule = rule
  end

  def call
    users = Array.new

    if @rule[:match] === "=" # exact match
      segment = Segment.where(name: @rule[:properties][:name])
      users = segment.user_ids
    else
      users = []
    end

    users.uniq
  end
end
