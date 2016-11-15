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

  it "has filter as array" do
    segment = FactoryGirl.build(:segment)
    expect(segment.filters).to be_an(Array)
  end

  it "has rules as hashes" do
    segment = FactoryGirl.build(:segment)
    segment.filters.each do |filter|
      filter.each do |rule|
        expect(rule).to be_a(Hash)
      end
    end
  end

  it "has at least one filter with at least one rule" do
    segment = FactoryGirl.build(:segment)
    expect(segment.filters.count).to be >= 1
    expect(segment.filters.first.count).to be >=1
  end

  it "has users" do
    segment = FactoryGirl.build(:segment)
    expect(segment.users).to be_an(ActiveRecord::Associations::CollectionProxy)
  end

end
