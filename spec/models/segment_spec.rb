require 'rails_helper'

describe Segment do
  it "is valid with filters" do
    segment = FactoryGirl.build(:segment)

    expect(segment).to be_valid
  end

  it "is invalid without filters" do
    segment = FactoryGirl.build(:segment, filters: nil)

    segment.valid?
    expect(segment.errors[:filters]).to include("can't be blank")
  end

  it "has a valid factory" do
    expect(FactoryGirl.build(:segment)).to be_valid
  end

  it "has filter as array"
  it "has at least one filter with at least one rule"
  it "has users"
end
