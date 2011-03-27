require 'stepdown/step_collection'

module Stepdown
  class Scenario
    attr_reader :step_count
    def initialize
      @step_collection = Stepdown::StepCollection.new
      @step_count = 0
    end

    def add_step(step)
      @step_count += 1
      @step_collection.add_step(step.id, step.regex)
    end

    def steps
      @step_collection.steps
    end

    def unique_step_count
      @step_collection.length
    end

  end
end