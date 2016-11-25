require 'rails_helper'

RSpec.describe Workflow, type: :model do
  it "is valid with filters and actions" do
    workflow = FactoryGirl.build(:workflow)

    expect(workflow).to be_valid
  end

  it "is invalid without filters" do
    workflow = FactoryGirl.build(:workflow, filters: nil)

    workflow.valid?
    expect(workflow.errors[:filters]).to include("can't be blank")
  end

  it "is invalid without filters" do
    workflow = FactoryGirl.build(:workflow, filters: nil)

    workflow.valid?
    expect(workflow.errors[:filters]).to include("can't be blank")
  end

  it "has filter as array" do
    workflow = FactoryGirl.build(:workflow)

    expect(workflow.filters).to be_an(Array)
  end

  it "has actions as array" do
    workflow = FactoryGirl.build(:workflow)

    expect(workflow.actions).to be_an(Array)
  end
end
