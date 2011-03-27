require 'stepdown/step'

module Stepdown
  class StepCollection
    include Enumerable

    def initialize
      @steps = {}
    end

    def add_step(id, regex)
      if @steps[id]
        @steps[id].count += 1
      else
        @steps[id] = Stepdown::Step.new(id, regex)
        @steps[id].count = 1
      end
    end

    def steps
      @steps.collect{|id,step| step }
    end

    def each
      @steps.each{|s| yield s[1] }
    end

    def length
      @steps.length
    end
  end
end