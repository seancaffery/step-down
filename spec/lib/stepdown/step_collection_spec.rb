require 'spec_helper'
require 'step_collection'
require 'step'

describe Stepdown::StepCollection do

  before :each do
    @collection = Stepdown::StepCollection.new
  end

  it "should return an empty hash when for an empty group" do
    @collection.steps.should be_empty
  end

  it "should return the current steps in the group" do
    @collection.add_step(1,/regex 1/)
    @collection.add_step(2,/regex 2/)
    @collection.add_step(3,/regex 3/)

    @collection.steps[1].regex.should == /regex 1/
    @collection.steps[2].regex.should == /regex 2/
    @collection.steps[3].regex.should == /regex 3/
  end

  describe "adding a step to the step group" do
    before :each do
      @collection = Stepdown::StepCollection.new
    end

    it "should add new steps" do
      step = mock("step")
      Stepdown::Step.stub!(:new).and_return(step)
      step.should_receive(:count=).with(1)
      @collection.add_step(1, /regex/)
      @collection.steps.should ==  {1 => step}

    end

    it "should update the count for an existing step" do

      @collection.add_step(1,/regex/)
      @collection.add_step(1,/regex/)

      @collection.steps[1].count.should == 2
    end

    it "should update step counts when multiple steps present" do
      @collection.add_step(1,/regex/)
      @collection.add_step(1,/regex/)

      @collection.add_step(2,/regex/)

      @collection.add_step(3,/regex/)
      @collection.add_step(3,/regex/)
      @collection.add_step(3,/regex/)

      @collection.steps[1].count.should == 2
      @collection.steps[2].count.should == 1
      @collection.steps[3].count.should == 3

    end

  end

end