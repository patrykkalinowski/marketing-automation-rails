class BuildWorkflow < BuildSegment

  def initialize(workflow)
    @workflow = workflow
  end

  def call
    users_to_add = users_meeting_requirements_for(@workflow)

    # Launch workflow for new users
    users_to_add.each do |user|
      unless @workflow.users.exists?(user)
        launch_workflow_for(user)
      end
    end

    add_users(@workflow, users_to_add)
  end

  private

  def launch_workflow_for(user)
    workflow_launcher = LaunchWorkflow.new(user: user, workflow: @workflow)
    workflow_launcher.call
  end
end
