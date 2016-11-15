class BuildSegment::FindEvents

  def initialize(rule)
    @rule = rule
  end

  def call
    users = Array.new

    if @rule[:match] === "=" # exact match
      relation = Ahoy::Event.where_properties(@rule[:properties])

    elsif @rule[:match] === "^" # begins with
      relation = Ahoy::Event.where.not(user_id: nil).where("properties->>'#{@rule[:properties].keys.first.to_s}' LIKE ?", "#{@rule[:properties].values.first.to_s}%")

    elsif @rule[:match] === "~" # includes
      relation = Ahoy::Event.where.not(user_id: nil).where("properties->>'#{@rule[:properties].keys.first.to_s}' LIKE ?", "%#{@rule[:properties].values.first.to_s}%")

    elsif @rule[:match] === "$" # ends with
      relation = Ahoy::Event.where.not(user_id: nil).where("properties->>'#{@rule[:properties].keys.first.to_s}' LIKE ?", "%#{@rule[:properties].values.first.to_s}")

    elsif @rule[:match] === "!=" # does not match
      relation = Ahoy::Event.where.not(user_id: nil).where.not("properties->>'#{@rule[:properties].keys.first.to_s}' = ?", "#{@rule[:properties].values.first.to_s}")

    elsif @rule[:match] === "!^" # does not start with
      relation = Ahoy::Event.where.not(user_id: nil).where.not("properties->>'#{@rule[:properties].keys.first.to_s}' LIKE ?", "#{@rule[:properties].values.first.to_s}%")

    elsif @rule[:match] === "!~" # does not contain
      relation = Ahoy::Event.where.not(user_id: nil).where.not("properties->>'#{@rule[:properties].keys.first.to_s}' LIKE ?", "%#{@rule[:properties].values.first.to_s}%")

    elsif @rule[:match] === "!$" # does not end with
      relation = Ahoy::Event.where.not(user_id: nil).where.not("properties->>'#{@rule[:properties].keys.first.to_s}' LIKE ?", "%#{@rule[:properties].values.first.to_s}")

    elsif @rule[:match] === "empty" # is empty
      relation = Ahoy::Event.where.not(user_id: nil).where("properties->>'#{@rule[:properties].keys.first.to_s}' = ?", "")

    elsif @rule[:match] === "!empty" # is not empty
      relation = Ahoy::Event.where.not(user_id: nil).where.not("properties->>'#{@rule[:properties].keys.first.to_s}' = ?", "")
    else
      # return no users if rule not found
      # TODO: log error
      return []
    end

    relation.each do |event|
      users << event.user_id
    end

    users.uniq
  end

end
