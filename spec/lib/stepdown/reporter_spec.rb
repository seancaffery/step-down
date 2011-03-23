require 'step_group'
require 'step_usage'
require 'reporter'

describe Stepdown::Reporter do

  describe "returning overall statistics" do
    it "should return the total number of steps" do
      steps = [mock('step_1'), mock('step_2')]
      reporter = Stepdown::Reporter.new([], steps)
      reporter.total_steps.should == 2
    end

    it "should return the total number of scenarios" do
      scenarios = [mock('scenario_1'), mock('scenario_2')]
      reporter = Stepdown::Reporter.new(scenarios, [])
      reporter.total_scenarios.should == 2
    end

    it "should return the number of steps per scenario" do
      steps = [mock('step_1'), mock('step_2'), mock('step_3')]
      scenario1 = mock("scenario1", :steps => steps, :step_count => steps.length)
      scenario2 = mock("scenario2", :steps => [], :step_count => 0)

      reporter = Stepdown::Reporter.new([scenario1, scenario2], [])
      reporter.steps_per_scenario.should == "1.50"
    end

    it "should return the number of unique steps per scenario" do
      steps = [mock('step_1'), mock('step_2'), mock('step_3')]
      scenario1 = mock("scenario1", :steps => steps, :unique_step_count => 2, :step_count => 3)
      scenario2 = mock("scenario2", :steps => steps[0...1], :unique_step_count => 1, :step_count => 1)

      reporter = Stepdown::Reporter.new([scenario1, scenario2], [])
      reporter.unique_steps.should == "1.33"
    end

  end

  describe "creating step groupings" do
  end

  describe "creating step usages" do
  end

  describe "returing step usage" do
    it "should return unused steps"
    it "should return used steps"
  end

end
