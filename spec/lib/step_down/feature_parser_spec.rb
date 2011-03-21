require 'spec_helper'
require 'scenario'
require 'feature_parser'

describe FeatureParser do
  def stub_line_match_with(instance, line, value)
    instance.stub!(:line_matches).with(line).and_return(value)
  end

  describe "creating scenarios" do
    before :each do
    end
    it "should create a scenario for a scenario line" do

      file = mock("file")
      instance = mock("instance")
      file_lines = ["Scenario: My testing scenario"]

      @parser = FeatureParser.new
      @parser.should_receive(:read_feature_file).with(file).and_return(file_lines)
      scenario = mock("scenario")
      Scenario.should_receive(:new).and_return(scenario)
      
      @parser.process_feature(file, instance).should =~ [scenario]
    end
 
    it "should create a scenario for a background line" do
      file = mock("file")
      instance = mock("instance")
      file_lines = ["Background: My testing scenario"]

      @parser = FeatureParser.new
      @parser.should_receive(:read_feature_file).with(file).and_return(file_lines)
      scenario = mock("scenario")
      Scenario.should_receive(:new).and_return(scenario)
      
      @parser.process_feature(file, instance).should =~ [scenario]
    end
  end


  describe "parsing step lines" do
    before :each do 
      @parser = FeatureParser.new
      @step_instance = mock("step_instance")

    end

    it "should not add unmatched steps" do
      lines = ["Scenario", "matched", "match 2"]
      unmatched_lines = ["not matched", "not matched 2"]
      steps = []
      lines.each_with_index do |line, i|
        step = Step.new(i, line)
        stub_line_match_with(@step_instance, line, step)
        steps << step
      end
      
      unmatched_lines.each do |line|
        stub_line_match_with(@step_instance, line, nil)
      end

      all_lines = [lines, unmatched_lines].flatten
      @parser.should_receive(:read_feature_file).and_return(all_lines)

      scenarios = @parser.process_feature(mock('file'), @step_instance)
      scenarios.first.steps.should =~ steps[1..2]
    end

    it "should add matched steps" do
      lines = ["Scenario", "matched", "match 2"]
      steps = []
      lines.each_with_index do |line, i|
        step = Step.new(i, line)
        stub_line_match_with(@step_instance, line, step)
        steps << step
      end
      @parser.should_receive(:read_feature_file).and_return(lines)

      scenarios = @parser.process_feature(mock('file'), @step_instance)
      scenarios.first.steps.should =~ steps[1..2]

    end

  end
end
