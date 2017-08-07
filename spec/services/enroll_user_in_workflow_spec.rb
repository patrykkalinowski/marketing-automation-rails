require 'rails_helper'

describe EnrollUserInWorkflow do
  ActiveJob::Base.queue_adapter = :test
  
  it 'schedules workflow email to send' do

    workflow = FactoryGirl.create(:workflow)
    user = FactoryGirl.create(:user)
    workflow.users << user

    enroll = EnrollUserInWorkflow.new(user: user, workflow: workflow)

    expect { enroll.call }.to expect { MessageWorker }.to have_enqueued_job
  end
end
