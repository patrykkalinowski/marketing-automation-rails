class MessageWorker
  include Sidekiq::Worker

  def perform(user_id)
    WorkflowMailer.basic(user_id).deliver_later
  end
end
