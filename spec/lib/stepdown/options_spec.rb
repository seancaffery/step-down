require 'spec_helper'
require 'options'

describe Stepdown::Options do

  before :each do
    @options = Stepdown::Options.new
  end

  describe "setting input directories" do
    it "should allow setting only steps directory" do
      @options.parse(["--steps=step_dir"])

      expect(@options.steps_dir).to eq "step_dir"
      expect(@options.features_dir).to eq "features"
    end

    it "should allow setting only features directory" do
      @options.parse(["--features=features_dir"])

      expect(@options.steps_dir).to eq "features/step_definitions"
      expect(@options.features_dir).to eq "features_dir"
    end

    it "should allow setting features and settings directory" do
      @options.parse(["--features=features_dir", "--steps=steps_dir"])

      expect(@options.steps_dir).to eq "steps_dir"
      expect(@options.features_dir).to eq "features_dir"
    end
  end

  describe "selecting reporter" do
    it "should select html by default" do
      @options.parse([])

      expect(@options.reporter).to eq "html"
    end

    it "should allow selecting html" do
      @options.parse(["--output=html"])

      expect(@options.reporter).to eq "html"
    end

    it "should allow selecting text" do
      @options.parse(["--output=text"])

      expect(@options.reporter).to eq "text"
    end
  end

  describe "using default directories" do
    it "should select relative step directory" do
      @options.parse([])

      expect(@options.steps_dir).to eq "features/step_definitions"
    end

    it "should select relative feature directory" do
      @options.parse([])

      expect(@options.features_dir).to eq "features"
    end
  end

  describe "validating options" do
    require 'stringio'
    before :each do
      allow(Dir).to receive(:pwd).and_return("")
      @io = StringIO.new
    end

    it "should report an invalid steps directory" do
      @options.parse(["--steps=steps_dir"])
      expect do
        @options.validate(@io)
        expect(@io.string).to eq "Directory steps_dir does not exist"
      end.to raise_error(SystemExit)
    end

    it "should report an invalid features directory" do
      @options.parse(["--features=features_dir"])
      expect do
        @options.validate(@io)
        expect(@io.string).to eq "Directory features_dir does not exist"
      end.to raise_error(SystemExit)
    end

    it "should allow output to be supressed" do
      @options.parse(["-q"])
      expect(@options.quiet).to be true
    end
  end

end

