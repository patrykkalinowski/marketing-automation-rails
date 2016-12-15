require 'rails_helper'

RSpec.describe SendMessageJob, type: :job do
  include ActiveJob::TestHelper

  it { is_expected.to be_processed_in :default }
  
  it 'schedules message for user' do
    ActiveJob::Base.queue_adapter = :test

    workflow = FactoryGirl.create(:workflow)
    user = FactoryGirl.create(:user)
    workflow.users << user

    enroll = EnrollUserInWorkflow.new(user: user, workflow: workflow)
    enroll.call

    expect {
      SendMessageJob.to have_enqueued_job.with(user, workflow[:actions].first[:id])
    }
    expect(enqueued_jobs.size).to eq(1)
  end


end
