require File.expand_path(File.dirname(__FILE__) + '/../../lib/step_instance')
require File.expand_path(File.dirname(__FILE__) + '/../../lib/step')


describe StepInstance do

  before :each do 
    @step_instance = StepInstance.new
  end

  it "should deal with missing constants" do
    lambda{ @step_instance.instance_eval("MissingConst") }.should_not raise_error
    lambda{ @step_instance.instance_eval("MissingConst::MissingClass") }.should_not raise_error
    lambda{ @step_instance.instance_eval("MissingConst::MissingClass.missing_method") }.should_not raise_error
  end

  it "should deal with missing methods" do
     lambda{ @step_instance.doesnt_exist }.should_not raise_error
     lambda{ StepInstance.doesnt_exist }.should_not raise_error
  end

  describe "returning steps" do
    it "should return parsed steps" do
      @step_instance.Given(/given/)
      @step_instance.When(/when/)
      @step_instance.Then(/then/)

      @step_instance.steps.length.should == 3
    end

  end

  describe "returning matched steps" do
    it "should return nil when no matching step found" do
      @step_instance.Given(/some step/)
      @step_instance.line_matches("Given some other step").should be_nil
    end

    it "should parse And steps" do
      @step_instance.Given(/matched step/)
      @step_instance.line_matches("And matched step").regex.should == /matched step/
    end

    it "should parse Given steps" do
      @step_instance.Given(/matched step/)
      @step_instance.line_matches("Given matched step").regex.should == /matched step/
    end

    it "should parse When steps" do
      @step_instance.When(/matched step/)
      @step_instance.line_matches("When matched step").regex.should == /matched step/
    end

    it "should parse Then steps" do
      @step_instance.Then(/matched step/)
      @step_instance.line_matches("Then matched step").regex.should == /matched step/
    end

  end
  
  describe "parsing step definitions" do
    before :each do
      @regex = /reg/
      @step = mock('step')
      Step.should_receive(:new).with(0, @regex).and_return(@step)
    end

    it "should define given steps" do
      @step_instance.Given(@regex)
      @step_instance.steps.should =~ [@step]
    end

    it "should define when steps" do
      @step_instance.When(@regex)
      @step_instance.steps.should =~ [@step]
    end

    it "should define then steps" do
      @step_instance.Then(@regex)
      @step_instance.steps.should =~ [@step]
    end
  end
end
