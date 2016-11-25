class EnrollInWorkflow
  @@logger = Logger.new("#{Rails.root}/log/automation.log")

  def initialize(params)
    @user = params[:user]
    @workflow = params[:workflow]

  end

  def call
    @@logger.info "User (id: #{@user.id}, email: #{@user.email}) enrolled in workflow (id: #{@workflow.id}, name: #{@workflow.name})"

    @workflow.actions.each do |action|
      if action[:name] == "$email"
        @@logger.info "Action: #{action[:action]} #{action[:name]} with id #{action[:id]} to #{@user.email} with #{action[:delay]} seconds of delay"
      end
    end
  end

end
