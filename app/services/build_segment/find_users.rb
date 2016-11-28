class BuildSegment::FindUsers

  def initialize(params)
    @key = User.connection.quote_column_name(params[:key])
    @negative = params[:negative]
    @pattern = params[:pattern]
  end

  def call
    if @negative
      users = User.where.not("#{@key} ILIKE ?", @pattern)
    else
      users = User.where("#{@key} ILIKE ?", @pattern)
    end

    users.uniq
  end
end
