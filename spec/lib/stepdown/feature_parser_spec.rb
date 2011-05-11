require 'spec_helper'
require 'scenario'
require 'feature_parser'

describe Stepdown::FeatureParser do
  def stub_line_match_with(instance, line, value)
    instance.stub!(:line_matches).with(line).and_return(value)
  end

  describe "creating scenarios" do
    before :each do
      instance = mock("instance")
      @parser = Stepdown::FeatureParser.new(instance)
    end

    it "should create a scenario for a scenario line" do

      scenario = mock("scenario")
      Stepdown::Scenario.should_receive(:new).and_return(scenario)
      @parser.scenario(scenario)

      @parser.scenarios.should =~ [scenario]
    end
 
    it "should create a scenario for a background line" do

      background = mock("background")
      Stepdown::Scenario.should_receive(:new).and_return(background)
      @parser.background(background)

      @parser.scenarios.should =~ [background]
    end

    it "should create a scenario for a scenario outline" do

      outline = mock("outline")
      Stepdown::Scenario.should_receive(:new).and_return(outline)
      @parser.scenario_outline(outline)

      @parser.scenarios.should =~ [outline]
    end
  end


  describe "parsing step lines" do
    before :each do 
      @step_instance = mock("step_instance")
      @parser = Stepdown::FeatureParser.new(@step_instance)
      @parser.scenario(mock('scenario'))

    end

    it "should not add unmatched steps" do
      lines = ["matched", "match 2"]
      unmatched_lines = ["not matched", "not matched 2"]
      steps = []
      lines.each_with_index do |line, i|
        step = Stepdown::Step.new(i, line)
        stub_line_match_with(@step_instance, line, step)
        steps << step
      end
      
      unmatched_lines.each do |line|
        stub_line_match_with(@step_instance, line, nil)
      end

      all_lines = [lines, unmatched_lines].flatten

      all_lines.each do |line|
        @parser.step(mock('step', :name => line))
      end

      scenarios = @parser.scenarios
      scenarios.first.steps.collect{|s| s.regex }.should =~ ["matched", "match 2"]
    end

    it "should add matched steps" do
      lines = ["matched", "match 2"]
      steps = []
      lines.each_with_index do |line, i|
        step = Stepdown::Step.new(i, line)
        stub_line_match_with(@step_instance, line, step)
        @parser.step(mock('step', :name => line))
        steps << step
      end

      scenarios = @parser.scenarios
      scenarios.first.steps.collect{|s| s.regex }.should =~ ["matched", "match 2"]

    end

  end
end
