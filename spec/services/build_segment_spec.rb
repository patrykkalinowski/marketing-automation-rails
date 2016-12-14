require 'rails_helper'

describe BuildSegment do
  it "adds users to segment" do
    segment = FactoryGirl.build(:segment)
    FactoryGirl.build(:ahoy_event)
  end

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

  it "finds users to add to segment from multiple events" do
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

  it "finds user who visited url with params" do
    segment = FactoryGirl.create(:segment_url_params)
    FactoryGirl.create(:ahoy_event_params)
    FactoryGirl.create(:user)

    segment_builder = BuildSegment.new(segment)
    expect(segment_builder.call).to eql([1])
  end

  it "finds user2 who visited url with params" do
    segment = FactoryGirl.create(:segment_url_params)
    FactoryGirl.create(:ahoy_event_params_user2)
    FactoryGirl.create(:user2)

    segment_builder = BuildSegment.new(segment)
    expect(segment_builder.call).to eql([2])
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

  it "finds users with custom events" do
    segment = FactoryGirl.create(:segment_custom_event)
    FactoryGirl.create(:user)
    FactoryGirl.create(:ahoy_event_name)

    segment_builder = BuildSegment.new(segment)
    expect(segment_builder.call).to eql([1])
  end

  it "is not case sensitive" do
    segment = FactoryGirl.create(:segment_custom_event)
    FactoryGirl.create(:user)
    FactoryGirl.create(:ahoy_event_name_lowercase)

    segment_builder = BuildSegment.new(segment)
    expect(segment_builder.call).to eql([1])
  end



  it "ignores events with no user" do
    segment = FactoryGirl.create(:segment)
    FactoryGirl.create(:ahoy_event_no_user)

    segment_builder = BuildSegment.new(segment)
    expect(segment_builder.call).to eql([])
  end

  it "is protected from SQL injection in users" do
    segment = FactoryGirl.create(:segment_sqli)
    FactoryGirl.create(:user)
    FactoryGirl.create(:user2)

    segment_builder = BuildSegment.new(segment)
    expect { segment_builder.call }.to raise_error(ActiveRecord::StatementInvalid)
  end
end
