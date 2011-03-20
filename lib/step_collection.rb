require 'counting_step'

class StepCollection
  include Enumerable
  attr_reader :steps

  def initialize
    @steps = {}
  end

  def add_step(step)
    if @steps[step.id]
      @steps[step.id].count += 1
    else
      @steps[step.id] = CountingStep.new(step.id, step.regex)
      @steps[step.id].count = 1
    end
  end
  alias_method :<<, :add_step

  def each
    @steps.each{|s| yield s[1] }
  end

end