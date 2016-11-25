class BuildSegment::FindUsers

  def initialize(params)
    # @key = User.connection.quote_column_name(params[:key])
    @key = params[:key]
    @negative = params[:negative]
    @pattern = params[:pattern]
  end

  def call
    if @negative
      users = User.where.not("#{@key} LIKE ?", @pattern)
    else
      users = User.where("#{@key} LIKE ?", @pattern)
    end

    users.uniq
  end
end
