module Stepdown
  class Scenario

    def add_step(step)
      steps << step
    end

    def steps
      @steps ||= []
    end

    def uniq_steps
      uniq_steps = []
      steps.each do |step|
        uniq_steps << step unless uniq_steps.any?{|uniq| uniq.id == step.id}
      end
      uniq_steps
    end

  end
end