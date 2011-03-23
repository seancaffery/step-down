require 'step'

module Stepdown
  class StepCollection
    include Enumerable
    attr_reader :steps

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

    def each
      @steps.each{|s| yield s[1] }
    end

    def length
      @steps.length
    end
  end
end