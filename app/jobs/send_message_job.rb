class SendMessageJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    p "Sending message"
  end
end
