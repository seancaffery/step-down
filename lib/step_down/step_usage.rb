
module Stepdown
  class StepUsage

    attr_accessor :total_usage, :number_scenarios, :use_scenario
    attr_reader :step

    def initialize(step)
      @step = step
      @total_usage = 0
      @number_scenarios = 0
      @use_scenario = 0.0
    end
  end
end
