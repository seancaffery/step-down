require 'step_group'
require 'counting_step'
require 'step'

describe StepGroup do

  describe "returning the number of steps that are near the current step" do
    before :each do
      @step_group = StepGroup.new(Step.new(0,/regex/))
    end

    it "should return the steps ordered by use count" do
      @step_group.add_step(Step.new(1,/regex/))
      @step_group.add_step(Step.new(1,/regex/))
      @step_group.add_step(Step.new(3,/regex/))
      @step_group.add_step(Step.new(3,/regex/))
      @step_group.add_step(Step.new(3,/regex/))
      @step_group.add_step(Step.new(2,/regex/))

      @step_group.step_collection[0].count.should == 3
      @step_group.step_collection[1].count.should == 2
      @step_group.step_collection[2].count.should == 1
    end

  end

  describe "updating the use count of the main step" do
    before :each do
      @step_group = StepGroup.new(Step.new(0,/regex/))
    end

    it "should return 0 for an empty group" do
      @step_group.update_use_count.should be_zero
    end

    it "should return the total use" do
      @step_group.add_step(Step.new(1,/regex/))
      @step_group.add_step(Step.new(1,/regex/))
      @step_group.add_step(Step.new(3,/regex/))
      @step_group.add_step(Step.new(4,/regex/))
      @step_group.add_step(Step.new(1,/regex/))

      @step_group.update_use_count.should == 5
    end

    it "should update the use when new steps are added" do
      @step_group.add_step(Step.new(1,/regex/))
      @step_group.add_step(Step.new(1,/regex/))

      @step_group.update_use_count.should == 2

      @step_group.add_step(Step.new(3,/regex/))
      @step_group.add_step(Step.new(4,/regex/))
      @step_group.add_step(Step.new(1,/regex/))

      @step_group.update_use_count.should == 5
    end

  end

end
