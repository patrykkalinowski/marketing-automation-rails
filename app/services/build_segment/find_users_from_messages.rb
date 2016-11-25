class BuildSegment::FindUsersFromMessages

  def initialize(params)
    @key = Ahoy::Message.connection.quote_column_name(params[:key])
    @negative = params[:negative]
    @pattern = params[:pattern]
  end

  def call
    if @negative
      relation = Ahoy::Message.where.not(user_id: nil).where.not("#{@key} LIKE ?", @pattern)
    else
      relation = Ahoy::Message.where.not(user_id: nil).where("#{@key} LIKE ?", @pattern)
    end

    users = Array.new

    relation.each do |message|
      users << message.user_id
    end

    users.uniq
  end
end
