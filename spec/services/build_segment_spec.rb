require 'rails_helper'

describe BuildSegment do
  it "adds users to segment"
    segment = FactoryGirl.build(:segment)
    FactoryGirl.build(:ahoy_event)
  it "removes users from segment"
  it "finds users meeting requirements for segment"
  it "finds users passing filter"
  it "finds users to add" do
    segment = FactoryGirl.create(:segment)
    FactoryGirl.create(:ahoy_event)
    FactoryGirl.create(:ahoy_event_no_user)
    FactoryGirl.create(:ahoy_event_user_2)
    FactoryGirl.create(:ahoy_event_params)
    FactoryGirl.create(:ahoy_event_params_user2)
    FactoryGirl.create(:ahoy_event_messages_index)
    FactoryGirl.create(:ahoy_event_messages_show)
    FactoryGirl.create(:ahoy_event_name)
    FactoryGirl.create(:user)
    FactoryGirl.create(:user2)

    expect(Ahoy::Event.all.count).to eql(8)
    
    rule = segment.filters.first.first
    find_users_to_add = BuildSegment::FindUsersToAdd.new(rule)
    found_users = find_users_to_add.call
    expect(found_users).to eql([1,2])
  end

  it "finds users passing rule" do
    segment = FactoryGirl.create(:segment)
    FactoryGirl.create(:ahoy_event)
    FactoryGirl.create(:ahoy_event_no_user)
    FactoryGirl.create(:ahoy_event_user_2)
    FactoryGirl.create(:ahoy_event_params)
    FactoryGirl.create(:ahoy_event_params_user2)
    FactoryGirl.create(:ahoy_event_messages_index)
    FactoryGirl.create(:ahoy_event_messages_show)
    FactoryGirl.create(:ahoy_event_name)
    FactoryGirl.create(:user)
    FactoryGirl.create(:user2)

    segment_builder = BuildSegment.new(segment)
    expect(segment_builder.call).to eql([1,2])
  end

  it "finds users visited url with params" do
    segment = FactoryGirl.create(:segment_url_params)
    FactoryGirl.create(:ahoy_event_params)
    FactoryGirl.create(:user)

    segment_builder = BuildSegment.new(segment)
    expect(segment_builder.call).to eql([1])
  end

  it "does not find users visited empty url" do
    segment = FactoryGirl.create(:segment_url_empty)
    FactoryGirl.create(:ahoy_event)
    FactoryGirl.create(:ahoy_event_no_user)
    FactoryGirl.create(:ahoy_event_user_2)
    FactoryGirl.create(:ahoy_event_params)
    FactoryGirl.create(:ahoy_event_params_user2)
    FactoryGirl.create(:ahoy_event_messages_index)
    FactoryGirl.create(:ahoy_event_messages_show)
    FactoryGirl.create(:ahoy_event_name)
    FactoryGirl.create(:user)
    FactoryGirl.create(:user2)

    segment_builder = BuildSegment.new(segment)
    expect(segment_builder.call).to eql([])
  end

  it "finds users with custom events"

end
