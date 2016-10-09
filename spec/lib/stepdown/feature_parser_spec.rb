require 'spec_helper'
require 'scenario'
require 'feature_parser'

describe Stepdown::FeatureParser do
  def stub_line_match_with(instance, line, value)
    allow(instance).to receive(:line_matches).with(line).and_return(value)
  end

  describe "creating scenarios" do
    before :each do
      instance = double("instance")
      @parser = Stepdown::FeatureParser.new(instance)
    end

    it "should create a scenario for a scenario line" do

      scenario = double("scenario", :name => 'scenario')
      expect(Stepdown::Scenario).to receive(:new).and_return(scenario)
      @parser.scenario(scenario)

      expect(@parser.scenarios).to match [scenario]
    end
 
    it "should create a scenario for a background line" do

      background = double("background", :name => '')
      expect(Stepdown::Scenario).to receive(:new).and_return(background)
      @parser.background(background)

      expect(@parser.scenarios).to match [background]
    end

    it "should create a scenario for a scenario outline" do

      outline = double("outline", :name => 'outline')
      expect(Stepdown::Scenario).to receive(:new).and_return(outline)
      @parser.scenario_outline(outline)

      expect(@parser.scenarios).to match [outline]
    end
  end


  describe "parsing step lines" do
    before :each do 
      @step_instance = double("step_instance")
      @parser = Stepdown::FeatureParser.new(@step_instance)
      @parser.scenario(double('scenario', :name => 'scenario'))
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
        @parser.step(double('step', :name => line))
      end

      scenarios = @parser.scenarios
      expect(scenarios.first.steps.collect{|s| s.regex }).to match ["matched", "match 2"]
    end

    it "should add matched steps" do
      lines = ["matched", "match 2"]
      steps = []
      lines.each_with_index do |line, i|
        step = Stepdown::Step.new(i, line)
        stub_line_match_with(@step_instance, line, step)
        @parser.step(double('step', :name => line))
        steps << step
      end

      scenarios = @parser.scenarios
      expect(scenarios.first.steps.collect{|s| s.regex }).to match ["matched", "match 2"]
    end

  end
end
