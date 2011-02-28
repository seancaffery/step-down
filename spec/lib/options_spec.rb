require 'rspec'
require File.expand_path(File.dirname(__FILE__) + '/../../lib/options')

describe Options do

  before :each do
  end

  describe "setting input directories" do
    it "should allow setting only steps directory" do
      Options.parse(["--steps=step_dir"])

      Options.steps_dir.should == "step_dir"
      Options.features_dir.should == "features"

    end

    it "should allow setting only features directory" do
      Options.parse(["--features=features_dir"])

      Options.steps_dir.should == "features/step_definitions"
      Options.features_dir.should == "features_dir"
    end

    it "should allow setting features and settings directory" do
      Options.parse(["--features=features_dir", "--steps=steps_dir"])

      Options.steps_dir.should == "steps_dir"
      Options.features_dir.should == "features_dir"
    end
  end

  describe "selecting reporter" do
    it "should select html by default" do
      Options.parse([])

      Options.reporter.should == "html"
    end

    it "should allow selecting html" do
      Options.parse(["--output=html"])

      Options.reporter.should == "html"
    end

    it "should allow selecting text" do
      Options.parse(["--output=text"])

      Options.reporter.should == "text"
    end
  end

  describe "using default directories" do
    it "should select relative step directory" do
      Options.parse([])

      Options.steps_dir == "features/step_definitions"
    end

    it "should select relative feature directory" do
      Options.parse([])

      Options.features_dir.should == "features"
    end
  end

  describe "validating options" do
    it "should report an invalid steps directory"
    it "should report an invalid features directory"

  end

end

