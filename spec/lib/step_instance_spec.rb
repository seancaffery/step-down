require 'rspec'
require File.expand_path(File.dirname(__FILE__) + '/../../lib/step_instance')


describe StepInstance do

  before :each do 
    @step_instance = StepInstance.new
  end

  it "should deal with missing constants" do
    lambda{ @step_instance.instance_eval("MissingConst") }.should_not raise_error
  end
  it "should deal with missing methods" do
     lambda{ @step_instance.doesnt_exist }.should_not raise_error
  end

  describe "steps" do

  end

  describe "line matches" do

  end

end
