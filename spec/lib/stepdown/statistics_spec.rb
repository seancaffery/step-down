require 'stepdown/step_group'
require 'stepdown/step_usage'
require 'stepdown/reporter'
require 'stepdown/scenario'
require 'stepdown/statistics'

describe Stepdown::Statistics do

  describe "returning overall statistics" do
    it "should return the total number of steps" do
      steps = [double('step_1'), double('step_2')]
      reporter = Stepdown::Statistics.new([], steps)
      expect(reporter.total_steps).to eq 2
    end

    it "should return the total number of scenarios" do
      scenarios = [double('scenario_1'), double('scenario_2')]
      reporter = Stepdown::Statistics.new(scenarios, [])
      expect(reporter.total_scenarios).to eq 2
    end

    it "should return the number of steps per scenario" do
      steps = [double('step_1'), double('step_2'), double('step_3')]
      scenario1 = double("scenario1", :steps => steps, :step_count => steps.length)
      scenario2 = double("scenario2", :steps => [], :step_count => 0)

      reporter = Stepdown::Statistics.new([scenario1, scenario2], [])
      expect(reporter.steps_per_scenario).to eq "1.50"
    end

    it "should return the number of unique steps per scenario" do
      steps = [double('step_1'), double('step_2'), double('step_3')]
      scenario1 = double("scenario1", :steps => steps, :unique_step_count => 2, :step_count => 3)
      scenario2 = double("scenario2", :steps => steps[0...1], :unique_step_count => 1, :step_count => 1)

      reporter = Stepdown::Statistics.new([scenario1, scenario2], [])
      expect(reporter.unique_steps).to eq "1.33"
    end

  end

  #this whole grouping thing needs to be refactored. Nasty.
  describe "creating step groupings" do
    before :each do
      @scen_1 = Stepdown::Scenario.new('scenario')
      @scen_2 = Stepdown::Scenario.new('scenario')
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
      reporter = Stepdown::Statistics.new([@scen_1, @scen_2], @collection)

      expect(reporter.groupings[0].step_collection).to eq [@s1,@s2,@s3,@s4,@s5]
      expect(reporter.groupings[1].step_collection).to eq [@s1,@s2,@s3,@s4,@s5]
      expect(reporter.groupings[2].step_collection).to eq [@s1,@s2,@s3,@s4]
      expect(reporter.groupings[3].step_collection).to eq [@s1,@s2,@s3,@s4]
      expect(reporter.groupings[4].step_collection).to eq [@s1,@s2,@s5]
    end

    it "should return usage for steps across scenarios" do
      reporter = Stepdown::Statistics.new([@scen_1, @scen_2], @collection)

      group_1 = reporter.groupings.detect{|g| g.id == 1}
      expect(group_1.use_count).to eq 8
    end

    it "should return usage for steps in scenarios with duplicated steps" do
      reporter = Stepdown::Statistics.new([@scen_1, @scen_2], @collection)

      group_5 = reporter.groupings.detect{|g| g.id == 5}
      expect(group_5.use_count).to eq 4
    end

  end

  #this usage thing needs to be refactored as well
  describe "creating step usages" do
    before :each do
      @scen_1 = Stepdown::Scenario.new('scenario')
      @scen_2 = Stepdown::Scenario.new('scenario')
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
      @scen_2.add_step(@s5)
    end

    it "should return the usage of across scenarios" do
      reporter = Stepdown::Statistics.new([@scen_2, @scen_1], @collection)

      usage = reporter.usages.detect{|use| use.step.id == 1}
      expect(usage.total_usage).to eq 3
      expect(usage.number_scenarios).to eq 2
      expect(usage.use_scenario).to eq "1.50"
    end

    it "should return duplicate usage of a step in a scenario" do
      reporter = Stepdown::Statistics.new([@scen_2, @scen_1], @collection)

      usage = reporter.usages.detect{|use| use.step.id == 5}
      expect(usage.total_usage).to eq 2
      expect(usage.number_scenarios).to eq 1
      expect(usage.use_scenario).to eq "2.00"
    end

    it "should return usage of a step in a scenario" do
      reporter = Stepdown::Statistics.new([@scen_2, @scen_1], @collection)

      usage = reporter.usages.detect{|use| use.step.id == 3}
      expect(usage.total_usage).to eq 1
      expect(usage.number_scenarios).to eq 1
      expect(usage.use_scenario).to eq "1.00"
    end

  end

  describe "returing step usage" do
    before :each do
      @reporter = Stepdown::Statistics.new([], double('step_colllection'))

      @use_1 = Stepdown::StepUsage.new(Stepdown::Step.new(1,/regex/))
      @use_2 = Stepdown::StepUsage.new(Stepdown::Step.new(2,/regex/))
      @use_3 = Stepdown::StepUsage.new(Stepdown::Step.new(3,/regex/))

      @use_1.total_usage += 1
      @use_2.total_usage += 1

      allow(@reporter).to receive(:step_usages).and_return([@use_1, @use_2, @use_3])
    end

    it "should return used steps" do
      expect(@reporter.usages).to match [@use_1, @use_2]
    end

    it "should return unused steps" do
      expect(@reporter.unused).to match [@use_3]
    end

    it "should return the number of unused steps" do
      expect(@reporter.unused_step_count).to eq 1
    end
  end

  describe "returning empty scenarios" do

    it "should return scenarios with no steps" do
      scen_1 = Stepdown::Scenario.new('scenario')
      scen_2 = Stepdown::Scenario.new('scenario')

      @reporter = Stepdown::Statistics.new([scen_1, scen_2], Stepdown::StepCollection.new)

      expect(@reporter.empty).to eq [scen_1,scen_2]
    end

    it "should not return scenarios with steps" do
      scen_1 = Stepdown::Scenario.new('scenario')
      scen_2 = Stepdown::Scenario.new('scenario')

      scen_1.add_step(Stepdown::Step.new(1,/regex/))

      @reporter = Stepdown::Statistics.new([scen_1, scen_2], Stepdown::StepCollection.new)

      expect(@reporter.empty).to eq [scen_2]
    end

  end

  describe "report helpers" do
    before :each do
      @top_10 = [1,2,3,4,5,6,7,8,9,10]
      @rest = [11,12]
      @all = @top_10 + @rest
      @stats = Stepdown::Statistics.new([], double('step_collection'))
    end

    methods = ["groupings", "usages", "empty", "unused"]

    methods.each do |method|
      it "should return the top 10 #{method}" do
        expect(@stats).to receive(method.to_sym).and_return(@all)
        expect(@stats.send("#{method}_top".to_sym)).to eql @top_10
      end
    end

    methods.each do |method|
      it "should return the rest of #{method}" do 
        allow(@stats).to receive(method.to_sym).and_return(@all)
        expect(@stats.send("#{method}_rest".to_sym)).to eql @rest
      end
    end

    methods.each do |method|
      it "should not break if there are not enough elements for a requested collection" do
        allow(@stats).to receive(method.to_sym).and_return([])
        expect(@stats.send("#{method}_rest".to_sym)).to be_empty
      end
    end

  end

end
