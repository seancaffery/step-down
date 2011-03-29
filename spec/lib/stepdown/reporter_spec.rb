require 'stepdown/step_group'
require 'stepdown/step_usage'
require 'stepdown/reporter'
require 'stepdown/scenario'

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

  #this whole grouping thing needs to be refactored. Nasty.
  describe "creating step groupings" do
    before :each do
      @scen_1 = Stepdown::Scenario.new
      @scen_2 = Stepdown::Scenario.new
      @scenarios = [@scen_1, @scen_2]

      @collection = Stepdown::StepCollection.new
      @s1 = Stepdown::Step.new(1, /step 1/)
      @s2 = Stepdown::Step.new(2, /step 2/)
      @s3 = Stepdown::Step.new(3, /step 3/)
      @s4 = Stepdown::Step.new(4, /step 4/)
      @s5 = Stepdown::Step.new(5, /step 5/)

      @collection.add_step(@s1.id, @s1.regex)
      @collection.add_step(@s2.id, @s2.regex)
      @collection.add_step(@s3.id, @s3.regex)
      @collection.add_step(@s4.id, @s4.regex)
      @collection.add_step(@s5.id, @s5.regex)

      @scen_1.add_step(@s1)
      @scen_1.add_step(@s2)
      @scen_1.add_step(@s3)
      @scen_1.add_step(@s4)

      @scen_2.add_step(@s1)
      @scen_2.add_step(@s2)
      @scen_2.add_step(@s1)
      @scen_2.add_step(@s5)

    end

    it "should return the correct step grouping" do
      reporter = Stepdown::Reporter.new([@scen_1, @scen_2], @collection)

      reporter.groupings[0].step_collection.should =~ [@s1,@s2,@s3,@s4,@s5]
      reporter.groupings[1].step_collection.should =~ [@s1,@s2,@s3,@s4,@s5]
      reporter.groupings[2].step_collection.should =~ [@s1,@s2,@s5]
      reporter.groupings[3].step_collection.should =~ [@s1,@s2,@s3,@s4]
      reporter.groupings[4].step_collection.should =~ [@s1,@s2,@s3,@s4]

    end

    it "should return usage for steps across scenarios" do
      reporter = Stepdown::Reporter.new([@scen_1, @scen_2], @collection)

      group_1 = reporter.groupings.detect{|g| g.id == 1}
      group_1.use_count.should == 8
    end

    it "should return usage for steps in scenarios with duplicated steps" do
      reporter = Stepdown::Reporter.new([@scen_1, @scen_2], @collection)

      group_5 = reporter.groupings.detect{|g| g.id == 5}
      group_5.use_count.should == 4
    end

  end

  describe "creating step usages" do

    it "should return the usage of each step"

  end

  describe "returing step usage" do
    before :each do
      @reporter = Stepdown::Reporter.new([], mock('step_colllection'))

      @use_1 = Stepdown::StepUsage.new(Stepdown::Step.new(1,/regex/))
      @use_2 = Stepdown::StepUsage.new(Stepdown::Step.new(2,/regex/))
      @use_3 = Stepdown::StepUsage.new(Stepdown::Step.new(3,/regex/))

      @use_1.total_usage += 1
      @use_2.total_usage += 1

      @reporter.stub!(:step_usages).and_return([@use_1, @use_2, @use_3])
    end

    it "should return unused steps" do
      @reporter.usages.should =~ [@use_1, @use_2]
    end

    it "should return used steps" do
      @reporter.unused_steps.should =~ [@use_3]
    end
  end

end
