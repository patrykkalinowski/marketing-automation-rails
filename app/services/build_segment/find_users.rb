class BuildSegment::FindUsers

  def initialize(rule)
    @rule = rule
  end

  def call
    users = Array.new

    if @rule[:match] === "=" # exact match
      users = User.where("#{@rule[:properties].keys.first.to_s} = ?", "#{@rule[:properties].values.first.to_s}")

    elsif @rule[:match] === "^" # begins with
      users = User.where("#{@rule[:properties].keys.first.to_s} LIKE ?", "#{@rule[:properties].values.first.to_s}%")

    elsif @rule[:match] === "~" # contains
      users = User.where("#{@rule[:properties].keys.first.to_s} LIKE ?", "%#{@rule[:properties].values.first.to_s}%")

    elsif @rule[:match] === "$" # ends with
      users = User.where("#{@rule[:properties].keys.first.to_s} LIKE ?", "%#{@rule[:properties].values.first.to_s}")

    elsif @rule[:match] === "!=" # does not match
      users = User.where.not("#{@rule[:properties].keys.first.to_s} = ?", "#{@rule[:properties].values.first.to_s}")

    elsif @rule[:match] === "!^" # does not begin with
      users = User.where.not("#{@rule[:properties].keys.first.to_s} LIKE ?", "#{@rule[:properties].values.first.to_s}%")

    elsif @rule[:match] === "!~" # does not contain
      users = User.where.not("#{@rule[:properties].keys.first.to_s} LIKE ?", "%#{@rule[:properties].values.first.to_s}%")

    elsif @rule[:match] === "!$" # does not end with
      users = User.where.not("#{@rule[:properties].keys.first.to_s} LIKE ?", "%#{@rule[:properties].values.first.to_s}")

    elsif @rule[:match] === "empty" # is empty
      users = User.where("#{@rule[:properties].keys.first.to_s} = ?", "")

    elsif @rule[:match] === "!empty" # is not empty
      users = User.where.not("#{@rule[:properties].keys.first.to_s} = ?", "")
    else
      users = []
    end

    users.uniq
  end
end
