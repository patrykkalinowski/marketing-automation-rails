require 'rails_helper'

describe EnrollUserInWorkflow do
  ActiveJob::Base.queue_adapter = :test
  
  include ActiveJob::TestHelper
  
  after do
    clear_enqueued_jobs
  end  
  
  it 'schedules workflow email to send' do

    workflow = FactoryGirl.create(:workflow)
    user = FactoryGirl.create(:user)
    workflow.users << user

    enroll = EnrollUserInWorkflow.new(user: user, workflow: workflow)

    email = enroll.call
    expect(enqueued_jobs.size).to eq(1)
  end
end
