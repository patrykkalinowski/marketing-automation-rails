class BuildSegment::FindMessages

  def initialize(rule)
    @rule = rule
  end

  def call
    users = Array.new

    if @rule[:match] === "=" # exact match
      relation = Ahoy::Message.where.not(user_id: nil).where("#{@rule[:properties].keys.first.to_s} = ?", "#{@rule[:properties].values.first.to_s}")

    elsif @rule[:match] === "^" # begins with
      relation = Ahoy::Message.where.not(user_id: nil).where("#{@rule[:properties].keys.first.to_s} LIKE ?", "#{@rule[:properties].values.first.to_s}%")

    elsif @rule[:match] === "~" # contains
      relation = Ahoy::Message.where.not(user_id: nil).where("#{@rule[:properties].keys.first.to_s} LIKE ?", "%#{@rule[:properties].values.first.to_s}%")

    elsif @rule[:match] === "$" # ends with
      relation = Ahoy::Message.where.not(user_id: nil).where("#{@rule[:properties].keys.first.to_s} LIKE ?", "%#{@rule[:properties].values.first.to_s}")

    elsif @rule[:match] === "!=" # does not match
      relation = Ahoy::Message.where.not(user_id: nil).where.not("#{@rule[:properties].keys.first.to_s} = ?", "#{@rule[:properties].values.first.to_s}")

    elsif @rule[:match] === "!^" # does not begin with
      relation = Ahoy::Message.where.not(user_id: nil).where.not("#{@rule[:properties].keys.first.to_s} LIKE ?", "#{@rule[:properties].values.first.to_s}%")

    elsif @rule[:match] === "!~" # does not contain
      relation = Ahoy::Message.where.not(user_id: nil).where.not("#{@rule[:properties].keys.first.to_s} LIKE ?", "%#{@rule[:properties].values.first.to_s}%")

    elsif @rule[:match] === "!$" # does not end with
      relation = Ahoy::Message.where.not(user_id: nil).where.not("#{@rule[:properties].keys.first.to_s} LIKE ?", "%#{@rule[:properties].values.first.to_s}")

    elsif @rule[:match] === "empty" # is empty
      relation = Ahoy::Message.where.not(user_id: nil).where("#{@rule[:properties].keys.first.to_s} = ?", "")

    elsif @rule[:match] === "!empty" # is not empty
      relation = Ahoy::Message.where.not(user_id: nil).where.not("#{@rule[:properties].keys.first.to_s} = ?", "")
    else
      relation = []
    end

    relation.each do |event|
      users << event.user_id
    end

    users.uniq
  end
end
