require 'step_group'
require 'step_usage'

class Reporter
  OUTPUT_DIR = "./stepdown"

  attr_reader :scenarios, :usages, :steps, :grouping
  
  def initialize(scenarios, steps)
    @scenarios = scenarios
    @steps = steps
  end

  def groupings
    @groupings ||= grouping(@scenarios)
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

  def grouping(scenarios)
    step_groups = @steps.collect{|step| StepGroup.new(step) }

    step_groups.each do |step_group|
      scenarios.each do |scenario|
         used = scenario.steps.any?{|s| s.id == step_group.id}

         if used
           scenario.steps.each do |scen_step|
             step_group.add_step(scen_step)
           end
           step_group.update_use_count
         end

      end

    end
    step_groups.sort{|a,b| b.use_count <=> a.use_count}
  end

  def step_usage(scenarios)
    usages = @steps.collect{|step| StepUsage.new(step) }
    scenarios.each do |scenario|

      scenario.steps.each do |step|
        usage = usages.detect{|use| use.step.id == step.id}
        usage.total_usage += 1 if usage
      end

      scenario.uniq_steps.each do |step|
        usage = usages.detect{|use| use.step.id == step.id}
        usage.number_scenarios += 1 if usage
      end

    end

    usages.each do |usage|
      if usage.number_scenarios > 0
        use = sprintf "%.2f", (usage.total_usage / Float(usage.number_scenarios))
        usage.use_scenario = use
      end
    end

    usages.sort{|a,b| b.total_usage <=> a.total_usage}
  end

  def step_usages
    @step_usages ||= step_usage(@scenarios)
  end

  def usages
    step_usages.select{|use| use.total_usage > 0 }
  end

  def unused_steps
    step_usages.select{|use| use.total_usage == 0}
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

