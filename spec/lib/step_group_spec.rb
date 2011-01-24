require 'rspec'
require File.expand_path(File.dirname(__FILE__) + '/../../lib/step_group')
require File.expand_path(File.dirname(__FILE__) + '/../../lib/step')

describe StepGroup do

  describe "returning the number of steps that are near the current step" do
    before :each do
      @step_group = StepGroup.new(Step.new(0,/regex/))
    end

    it "should return an empty hash when for an empty group" do
      @step_group.in_steps.should be_empty
    end

    it "should return the current steps in the group" do
      @step_group.add_step(Step.new(1,/regex/))
      @step_group.add_step(Step.new(2,/regex/))
      @step_group.add_step(Step.new(3,/regex/))

      @step_group.in_steps.count.should == 3
    end

    it "should return the steps ordered by use count" do
      @step_group.add_step(Step.new(1,/regex/))
      @step_group.add_step(Step.new(1,/regex/))
      @step_group.add_step(Step.new(3,/regex/))
      @step_group.add_step(Step.new(3,/regex/))
      @step_group.add_step(Step.new(3,/regex/))
      @step_group.add_step(Step.new(2,/regex/))

      @step_group.in_steps[0][1][:count].should == 3
      @step_group.in_steps[1][1][:count].should == 2
      @step_group.in_steps[2][1][:count].should == 1
    end

  end

  describe "adding a step to the step group" do
    before :each do
      @step_group = StepGroup.new(Step.new(0,/regex/))
    end

    it "should add new steps" do
      step1 = Step.new(1,/regex/)
      @step_group.add_step(step1)

      @step_group.in_steps.should == [[1, {:count => 1, :step => step1}]]

    end

    it "should update the count for an existing step" do

      step1 = Step.new(1,/regex/)
      @step_group.add_step(step1)
      @step_group.add_step(step1)

      @step_group.in_steps.should == [[1, {:count => 2, :step => step1}]]
    end

    it "should update step counts when multiple steps present" do
      step1 = Step.new(1,/regex/)
      @step_group.add_step(step1)
      @step_group.add_step(step1)

      step2 = Step.new(2,/regex/)
      @step_group.add_step(step2)

      step3 = Step.new(3,/regex/)
      @step_group.add_step(step3)
      @step_group.add_step(step3)
      @step_group.add_step(step3)

      @step_group.in_steps.should == [[3, {:count => 3, :step => step3}],
                                      [1, {:count => 2, :step => step1}],
                                      [2, {:count => 1, :step => step2}]]

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
