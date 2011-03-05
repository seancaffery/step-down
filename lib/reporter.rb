
class Reporter
  OUTPUT_DIR = "./stepdown"

  attr_reader :scenarios, :usages, :steps, :grouping
  
  def initialize(scenarios, usages, grouping, steps)
    @scenarios = scenarios
    @usages = usages
    @steps = steps
    @grouping = grouping
  end

  def groupings
    @grouping
  end

  def total_scenarios
    @scenarios.length
  end

  def total_steps
    @steps.length
  end

  def steps_per_scenario
    steps_scenario(@scenarios)
  end

  def unique_steps
    uniq_steps_per_scenario(@scenarios)
  end

  def usages
    @usages.select{|use| use.total_usage > 0 }
  end

  def unused_steps
    @usages.select{|use| use.total_usage == 0}
  end

  def uniq_steps_per_scenario(scenarios)
    total_steps = 0.0
    uniq_steps = 0.0
    scenarios.each do |scen|
      total_steps += scen.steps.length
      uniq_steps += scen.uniq_steps.length
    end
    sprintf "%.2f", (total_steps / uniq_steps)
  end

  def steps_scenario(scenarios)
    scen_count = scenarios.length
    step_count = 0.0
    scenarios.each do |scenario|
      step_count += scenario.steps.length
    end
    sprintf "%.2f", (step_count / scen_count)
  end

end

