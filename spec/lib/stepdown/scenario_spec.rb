require 'spec_helper'
require 'scenario'
require 'step'


describe Stepdown::Scenario do
  before :each do
    @scenario = Stepdown::Scenario.new
    @s1 = Stepdown::Step.new(1, /step 1/)
    @s2 = Stepdown::Step.new(2, /Step 2/)
    @s2_dup = Stepdown::Step.new(2, /Step 2/)
    @s3 = Stepdown::Step.new(3, /Step 3/)

  end

  describe "adding steps" do
    before :each do
      @scenario.add_step(@s1)
      @scenario.add_step(@s2)
      @scenario.add_step(@s2_dup)
      @scenario.add_step(@s3)
    end

    it "should add steps to cache" do
      steps = [@s1, @s2, @s3]
      @scenario.steps.should =~ steps
    end

    it "should return the total number of steps" do
      @scenario.step_count.should == 4
    end

    it "should return the number of unique steps" do
      @scenario.unique_step_count.should == 3
    end

  end

end

