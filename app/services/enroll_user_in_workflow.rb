class EnrollUserInWorkflow
  @@logger = Logger.new("#{Rails.root}/log/automation.log")

  def initialize(params)
    @user = params[:user]
    @workflow = params[:workflow]
  end

  def call
    @@logger.info "User (id: #{@user.id}, email: #{@user.email}) enrolled in workflow (id: #{@workflow.id}, name: #{@workflow.name})"

    @workflow.actions.each do |action|
      schedule_action(action)
    end
  end

  private

  def schedule_action(action)
    if action[:name] == "$email"
      schedule_message(action)
    elsif action[:name] == "$segment"
      schedule_segment(action)
    elsif action[:name] == "$workflow"
      schedule_workflow(action)
    end
  end

  def schedule_message(action)
    # action: {
    # name: "$email",
    # action: "send",
    # id: 1,
    # delay: 1000 }

    SendMessageJob.set(wait: action[:delay].seconds).perform_later(workflow_id: @workflow.id, user_id: @user.id, template_id: action[:id])
  end

  def schedule_segment(action)
    # name: "$segment",
    # action: "add",
    # id: 2,
    # delay: 1000
    # SegmentWorker
  end

  def schedule_workflow(action)
    # WorkflowWorker.perform_in(@delay.seconds)
  end



end
