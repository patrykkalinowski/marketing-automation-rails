require 'rails_helper'

RSpec.describe SendMessageJob, type: :job do
  include ActiveJob::TestHelper

  it 'schedules message for user' do
    ActiveJob::Base.queue_adapter = :test

    workflow = FactoryGirl.create(:workflow)
    user = FactoryGirl.create(:user)
    workflow.actions.each do |action|
      action_scheduler = ScheduleWorkflowAction.new(user: user, action: action)
      action_scheduler.call

      expect {
        SendMessageJob.to have_enqueued_job.with(user, action[:id])
      }

    end

    expect(enqueued_jobs.size).to eq(1)


  end
end
