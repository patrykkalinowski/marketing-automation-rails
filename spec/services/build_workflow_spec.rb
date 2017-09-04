require 'rails_helper'

describe BuildWorkflow do
  include ActiveJob::TestHelper
  
  after do
    clear_enqueued_jobs
  end 

  it "adds users to workflow queue" do
    FactoryGirl.create(:ahoy_event)
    FactoryGirl.create(:ahoy_event_no_user)
    FactoryGirl.create(:ahoy_event_params)
    FactoryGirl.create(:ahoy_event_messages_index)
    FactoryGirl.create(:ahoy_event_messages_show)
    FactoryGirl.create(:ahoy_event_name)
    FactoryGirl.create(:user)
    FactoryGirl.create(:user2)
    segment = FactoryGirl.build(:segment)
    workflow = FactoryGirl.create(:workflow)

    buildSegment = BuildSegment.new(segment)
    buildSegment.call

    build = BuildWorkflow.new(workflow)
    build.call

    expect(segment.users.any?).to eq(true)
    expect(buildSegment.call).to eql([1])
    expect(enqueued_jobs.size).to eq(1)
  end

  
end
