class StepUsage

  attr_accessor :total_useage, :number_scenarios, :use_scenario
  attr_reader :step

  def initialize(step)
    @step = step
    @total_useage = 0
    @number_screnarios = 0
    @use_scenario = 0.0
  end

end
