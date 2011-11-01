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

    @collection.steps.collect{|s| s.regex }.should =~ [/regex 1/,/regex 2/,/regex 3/]
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
      @collection.steps.should ==  [step]

    end

    it "should update the count for an existing step" do

      @collection.add_step(1,/regex/)
      @collection.add_step(1,/regex/)

      @collection.steps[0].count.should == 2
    end

    it "should update step counts when multiple steps present" do
      @collection.add_step(1,/regex/)
      @collection.add_step(1,/regex/)

      @collection.add_step(2,/regex/)

      @collection.add_step(3,/regex/)
      @collection.add_step(3,/regex/)
      @collection.add_step(3,/regex/)

      @collection.steps.detect{|s| s.id == 1}.count.should == 2
      @collection.steps.detect{|s| s.id == 2}.count.should == 1
      @collection.steps.detect{|s| s.id == 3}.count.should == 3

    end

  end

  describe "acting as an array" do
    before :each do
      @collection  = Stepdown::StepCollection.new
    end

    it "should return a step for an existing id" do
      @collection.add_step(0, /regex/)
      @collection[0].should be_instance_of(Stepdown::Step)
    end

    it "should return nil for a step that doesn't exist" do
      @collection[1].should be_nil
    end
  end

  describe "returning steps" do
    it "should return elements in the order that they are added" do

      @collection = Stepdown::StepCollection.new

      ids = [100, 42, 60]
      @collection.add_step(100, /step 1/)
      @collection.add_step(42, /step 2/)
      @collection.add_step(60, /step 3/)

      @collection.each_with_index{|step, i| step.id.should == ids[i] }
    end
  end


end