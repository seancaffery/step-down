require 'spec_helper'
require 'analyzer'
require 'reporter'
require 'html_reporter'
require 'text_reporter'
require 'stepdown'

describe Stepdown::Analyzer do

  before(:each) do
    @analyzer = Stepdown::Analyzer.new('','','html')
    Stepdown.quiet = true
  end

  describe "selecting a reporter" do

    it "should return an HTML reporter" do
      reporter = @analyzer.reporter('html', double('stats'))
      expect(reporter).to be_instance_of(Stepdown::HTMLReporter)
    end

    it "should return a text reporter" do
      reporter = @analyzer.reporter('text', double('stats'))
      expect(reporter).to be_instance_of(Stepdown::TextReporter)
    end

    it "should return a quiet reporter" do
      reporter = @analyzer.reporter('quiet', double('stats'))
      expect(reporter).to be_instance_of(Stepdown::Reporter)
    end

  end

  describe "#analyse" do
    it "should call the YamlWriter and Graph" do
      features = ["awesome.txt."]
      instance = double('instance', :step_collection => [])
      reporter = double('reporter')
      stats = double('stats')
      expect(reporter).to receive(:output_overview)

      expect(@analyzer).to receive(:instance).and_return(instance)
      expect(@analyzer).to receive(:feature_files).and_return(features)
      expect(@analyzer).to receive(:process_feature_files).with(features).and_return([])
      expect(@analyzer).to receive(:reporter).and_return(reporter)
      expect(stats).to receive(:generate)

      allow(Stepdown::Statistics).to receive(:new).with([], instance.step_collection).and_return(stats)
      expect(Stepdown::YamlWriter).to receive(:write).with(anything)
      expect(Stepdown::FlotGraph).to receive(:create_graph)

      @analyzer.analyze
    end
  end

  describe "#process_feature_files" do
    it "should instantiate a bunch of stuff" do
      double_listener = double(:listener)
      allow(@analyzer).to receive(:instance)
      expect(Stepdown::FeatureParser).to receive(:new).with(anything).and_return(double_listener)
      double_parser = double(:gherkin_parser)
      expect(Gherkin::Parser::Parser).to receive(:new).and_return(double_parser)
      allow(File).to receive(:read)
      expect(double_parser).to receive(:parse)
      expect(double_listener).to receive(:scenarios)
      @analyzer.process_feature_files(["blah.txt"])
    end
  end
end

