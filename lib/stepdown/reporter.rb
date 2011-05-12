require 'stepdown/step_group'
require 'stepdown/step_usage'

module Stepdown
  class Reporter
    OUTPUT_DIR = "./stepdown"

    attr_reader :scenarios, :usages, :step_collection, :grouping

    def initialize(scenarios, step_collection)
      @scenarios = scenarios
      @step_collection = step_collection
    end

    def groupings
      @groupings ||= grouping(@scenarios)
    end

    def total_scenarios
      @scenarios.length
    end

    def total_steps
      @step_collection.length
    end

    def steps_per_scenario
      steps_scenario(@scenarios)
    end

    def unique_steps
      uniq_steps_per_scenario(@scenarios)
    end

    def grouping(scenarios)
      step_groups = @step_collection.collect{|step| Stepdown::StepGroup.new(step) }

      step_groups.each do |step_group|
        scenarios.each do |scenario|

          if scenario.steps.any?{|step| step.id == step_group.id}
            step_group.add_steps(scenario.steps)
            step_group.update_use_count(scenario.step_count)
          end
        end

      end
      step_groups.sort{|a,b| b.use_count <=> a.use_count}
    end

    def step_usage(scenarios)
      usages = @step_collection.collect{|step| Stepdown::StepUsage.new(step) }
      scenarios.each do |scenario|

        scenario.steps.each do |step|
          usage = usages.detect{|use| use.step.id == step.id}
          if usage
            usage.total_usage += step.count
            usage.number_scenarios += 1
          end
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

    def unused_step_count
      unused_steps.length
    end

    def uniq_steps_per_scenario(scenarios)
      total_steps = 0.0
      uniq_steps = 0.0
      scenarios.each do |scen|
        total_steps += scen.step_count
        uniq_steps += scen.unique_step_count
      end
      sprintf "%.2f", (total_steps / uniq_steps)
    end

    def steps_scenario(scenarios)
      scen_count = scenarios.length
      step_count = 0.0
      scenarios.each do |scenario|
        step_count += scenario.step_count
      end
      sprintf "%.2f", (step_count / scen_count)
    end

    def empty_scenarios
      @scenarios.select do |scen|
        scen.steps.empty?
      end
    end

  end
end

