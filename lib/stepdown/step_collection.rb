require 'stepdown/step'

module Stepdown
  class StepCollection
    include Enumerable

    def initialize
      @steps = {}
      @addition_order = []
    end

    def add_step(id, regex)
      if @steps[id]
        @steps[id].count += 1
      else
        @steps[id] = Stepdown::Step.new(id, regex)
        @steps[id].count = 1
        @addition_order << id
      end
    end

    def steps
      @steps.collect{|id,step| step }
    end

    def each
      @addition_order.each{|id| yield @steps[id] }
    end

    def [](id)
      @steps[id]
    end

    def length
      @steps.length
    end
  end
end