class LaunchWorkflow

  def initialize(params)
    @workflow = params[:workflow]
    @user = params[:user]
  end

  def call
    @workflow.actions.each do |action|
      action_scheduler = ScheduleWorkflowAction.new(user: @user, action: action)
      action_scheduler.call
    end
  end

end
