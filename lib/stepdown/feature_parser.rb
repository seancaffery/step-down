require 'stepdown/step'
require 'stepdown/scenario'
module Stepdown
  class FeatureParser

    def initialize(instance)
      @instance = instance
      @scenarios = []
    end

    def scenarios
      unless @scenarios.last == @current_scenario
        @scenarios << @current_scenario
      end
      @scenarios.compact
    end

    def background(background)
      @scenarios << @current_scenario
      @current_scenario = Scenario.new(background.name)
    end

    def scenario(scenario)
      @scenarios << @current_scenario
      @current_scenario = Scenario.new(scenario.name)
    end

    def scenario_outline(scenario_outline)
      @scenarios << @current_scenario      
      @current_scenario = Scenario.new(scenario_outline.name)
    end

    def step(step)
      matched_step = @instance.line_matches(step.name)
      @current_scenario.add_step(matched_step) if matched_step
    end

    def uri(*args) end

    def feature(*args) end

    def examples(*args) end

    def comment(*args) end

    def tag(*args) end

    def table(*args) end

    def py_string(*args) end

    def eof(*args) end

    def syntax_error(*args)
      # raise "SYNTAX ERROR"
    end

  end
end

