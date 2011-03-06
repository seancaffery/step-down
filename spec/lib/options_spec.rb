require File.expand_path(File.dirname(__FILE__) + '/../../lib/options')

describe @options do

  before :each do
    @options = Options.new
  end

  describe "setting input directories" do
    it "should allow setting only steps directory" do
      @options.parse(["--steps=step_dir"])

      @options.steps_dir.should == "step_dir"
      @options.features_dir.should == "features"

    end

    it "should allow setting only features directory" do
      @options.parse(["--features=features_dir"])

      @options.steps_dir.should == "features/step_definitions"
      @options.features_dir.should == "features_dir"
    end

    it "should allow setting features and settings directory" do
      @options.parse(["--features=features_dir", "--steps=steps_dir"])

      @options.steps_dir.should == "steps_dir"
      @options.features_dir.should == "features_dir"
    end
  end

  describe "selecting reporter" do
    it "should select html by default" do
      @options.parse([])

      @options.reporter.should == "html"
    end

    it "should allow selecting html" do
      @options.parse(["--output=html"])

      @options.reporter.should == "html"
    end

    it "should allow selecting text" do
      @options.parse(["--output=text"])

      @options.reporter.should == "text"
    end
  end

  describe "using default directories" do
    it "should select relative step directory" do
      @options.parse([])

      @options.steps_dir == "features/step_definitions"
    end

    it "should select relative feature directory" do
      @options.parse([])

      @options.features_dir.should == "features"
    end
  end

  describe "validating options" do
    it "should report an invalid steps directory"
    it "should report an invalid features directory"

  end

end

