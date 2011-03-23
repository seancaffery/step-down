require 'step_collection'

module Stepdown
  class Scenario

    def initialize
      @step_collection = Stepdown::StepCollection.new
    end

    def add_step(step)
      @step_collection.add_step(step.id, step.regex)
    end

    def steps
      @step_collection.steps
    end

    def uniq_steps
      uniq_collection = Stepdown::StepCollection.new
      steps.each do |step|
        uniq_collection.add_step(step.id, step.regex) unless uniq_collection.any?{|uniq| uniq.id == step.id}
      end
      uniq_collection.steps
    end

  end
end