class BuildWorkflow < BuildSegment

  def initialize(workflow)
    @workflow = workflow
  end

  def call
    users_to_add = users_meeting_requirements_for(@workflow)

    add_users(@workflow, users_to_add)

    # TODO: Launch workflow for new users
  end

  private

  def launch_workflow_for(user)
    workflow_launcher = LaunchWorkflow.new(user: user, workflow: @workflow)
    workflow_launcher.call
  end
end
