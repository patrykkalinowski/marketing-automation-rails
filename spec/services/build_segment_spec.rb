require 'rails_helper'

describe BuildSegment do
  it "adds users to segment"
  it "removes users from segment"
  it "finds users meeting requirements for segment"
  it "finds users passing filter"
  it "finds users passing rule" do
    segment = FactoryGirl.build(:segment)
    FactoryGirl.create(:ahoy_event, class: Ahoy::Event)

    segment_builder = BuildSegment.new(segment)
    expect(segment_builder.call).to eql([1])
  end

end
