class ScheduleWorkflowAction

  def initialize(params)
    @user = params[:user]
    @action = params[:action]
    @delay = @action[:delay] # delay in seconds
  end

  def call
    if @action[:name] == "$email"
      schedule_message
    elsif @action[:name] == "$segment"
      schedule_segment
    elsif @action[:name] == "$workflow"
      schedule_workflow
    end
  end

  private

  def schedule_message
    SendMessageJob.set(wait: @delay.seconds).perform_later
  end

  def schedule_segment
    # SegmentWorker
  end

  def schedule_workflow
    # WorkflowWorker.perform_in(@delay.seconds)
  end


end
