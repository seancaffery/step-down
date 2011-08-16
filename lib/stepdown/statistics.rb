
module Stepdown
  class Statistics
    attr_reader :scenarios, :usages, :step_collection, :grouping

    def initialize(scenarios, step_collection)
      @scenarios = scenarios
      @step_collection = step_collection
    end

    def generate
      puts "Performing analysis..." unless Stepdown.quiet
      groupings
      step_usages
      empty
      steps_per_scenario
      unique_steps
    end

    def to_h
      stats = {}
      stats[:number_scenarios] = total_scenarios
      stats[:total_steps] = total_steps
      stats[:steps_per_scenario] = steps_per_scenario
      stats[:unused_steps] = unused_step_count
      stats
    end

    def groupings_rest
      groupings[10..groupings.length]
    end

    def groupings_top(limit = 10)
      groupings[0...limit]
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
      @steps_per_scenario ||= steps_scenario(@scenarios)
    end

    def unique_steps
      @uniq_steps_per_scenario ||= uniq_steps_per_scenario(@scenarios)
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

    def usages_top(limit = 10)
      usages[0...limit]
    end

    def usages_rest
      usages[10..usages.length]
    end

    def step_usages
      @step_usages ||= step_usage(@scenarios)
    end

    def usages
      step_usages.select{|use| use.total_usage > 0 }
    end

    def unused_rest
      unused[10..unused.length]
    end

    def unused_top(limit = 10)
      unused[0...limit]
    end

    def unused
      step_usages.select{|use| use.total_usage == 0}
    end

    def unused_step_count
      unused.length
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

    def empty_rest
      empty[10..empty.length]
    end

    def empty_top(limit = 10)
      empty[0...limit]
    end

    def empty
      @empty_scenarios ||= @scenarios.select do |scen|
        scen.steps.empty?
      end
      @empty_scenarios
    end
  end
end
