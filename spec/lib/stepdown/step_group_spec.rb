require 'spec_helper'
require 'step_group'
require 'step'

describe Stepdown::StepGroup do

  describe "returning the number of steps that are near the current step" do
    before :each do
      @step_group = Stepdown::StepGroup.new(Stepdown::Step.new(0,/regex/))
    end

    it "should return the steps ordered by use count" do
      @step_group.add_step(Stepdown::Step.new(1,/regex/))
      @step_group.add_step(Stepdown::Step.new(1,/regex/))
      @step_group.add_step(Stepdown::Step.new(3,/regex/))
      @step_group.add_step(Stepdown::Step.new(3,/regex/))
      @step_group.add_step(Stepdown::Step.new(3,/regex/))
      @step_group.add_step(Stepdown::Step.new(2,/regex/))

      expect(@step_group.step_collection[0].count).to eq 3
      expect(@step_group.step_collection[1].count).to eq 2
      expect(@step_group.step_collection[2].count).to eq 1
    end

  end

  describe "updating the use count of the main step" do
    before :each do
      @step_group = Stepdown::StepGroup.new(Stepdown::Step.new(0,/regex/))
    end

    it "should return 0 for an empty group" do
      expect(@step_group.use_count).to be_zero
    end

    it "should return 0 for an empty group" do
      @step_group.update_use_count(10)
      expect(@step_group.use_count).to eq 10
    end

  end

end
