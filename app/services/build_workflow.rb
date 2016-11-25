class BuildWorkflow < BuildSegment

  def initialize(workflow)
    @workflow = workflow
  end

  def call
    users_to_add = users_meeting_requirements_for(@workflow)

    add_users(@workflow, users_to_add)
  end
end
