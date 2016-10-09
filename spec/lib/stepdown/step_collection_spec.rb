require 'spec_helper'
require 'step_collection'
require 'step'

describe Stepdown::StepCollection do

  before :each do
    @collection = Stepdown::StepCollection.new
  end

  it "should return an empty hash when for an empty group" do
    expect(@collection.steps).to be_empty
  end

  it "should return the current steps in the group" do
    @collection.add_step(1,/regex 1/)
    @collection.add_step(2,/regex 2/)
    @collection.add_step(3,/regex 3/)

    expect(@collection.steps.collect{|s| s.regex }).to match [/regex 1/,/regex 2/,/regex 3/]
  end

  describe "adding a step to the step group" do
    before :each do
      @collection = Stepdown::StepCollection.new
    end

    it "should add new steps" do
      step = double("step")
      allow(Stepdown::Step).to receive(:new).and_return(step)
      expect(step).to receive(:count=).with(1)
      @collection.add_step(1, /regex/)
      expect(@collection.steps).to eq [step]
    end

    it "should update the count for an existing step" do

      @collection.add_step(1,/regex/)
      @collection.add_step(1,/regex/)

      expect(@collection.steps[0].count).to eq 2
    end

    it "should update step counts when multiple steps present" do
      @collection.add_step(1,/regex/)
      @collection.add_step(1,/regex/)

      @collection.add_step(2,/regex/)

      @collection.add_step(3,/regex/)
      @collection.add_step(3,/regex/)
      @collection.add_step(3,/regex/)

      expect(@collection.steps.detect{|s| s.id == 1}.count).to eq 2
      expect(@collection.steps.detect{|s| s.id == 2}.count).to eq 1
      expect(@collection.steps.detect{|s| s.id == 3}.count).to eq 3
    end

  end

  describe "acting as an array" do
    before :each do
      @collection  = Stepdown::StepCollection.new
    end

    it "should return a step for an existing id" do
      @collection.add_step(0, /regex/)
      expect(@collection[0]).to be_instance_of(Stepdown::Step)
    end

    it "should return nil for a step that doesn't exist" do
      expect(@collection[1]).to be_nil
    end
  end

  describe "returning steps" do
    it "should return elements in the order that they are added" do

      @collection = Stepdown::StepCollection.new

      ids = [100, 42, 60]
      @collection.add_step(100, /step 1/)
      @collection.add_step(42, /step 2/)
      @collection.add_step(60, /step 3/)

      @collection.each_with_index{|step, i| expect(step.id).to eq ids[i] }
    end
  end


end
