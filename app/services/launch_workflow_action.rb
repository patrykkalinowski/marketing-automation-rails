class LaunchWorkflowAction

  def initialize(params)
    @user = User.find(params[:user_id])
  end

  def launch_message
    # send email
  end

  def launch_segment
    # add/remove from segment
  end

  def launch_workflow
    # add/remove from workflow
  end

end
