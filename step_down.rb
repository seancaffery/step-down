require 'lib/feature_parser'
require 'pp'
class StepDown

  def initialize(steps_dir, feature_dir)
    @feature_files = Dir.glob(feature_dir + '/**/*.feature')
    @step_files = Dir.glob(steps_dir + '/**/*.rb')
  end

  def analyse
    parser = FeatureParser.new

    @scenarios = []
    @feature_files.each do |feature|
      @scenarios << parser.process_feature(feature, instance)
    end
    @scenarios.flatten!

    puts "Total number of scenarios: #{@scenarios.length}"
    puts "Total number of steps: #{instance.steps.length}"
    puts "Steps per scenario: #{steps_per_scenario(@scenarios)}"
    puts "Unique steps per scenario: #{uniq_steps_per_scenario(@scenarios)}"
    usage = step_usage(@scenarios)
    usage = usage.sort{|a,b| b[:count] <=> a[:count] }
    usage.each do |use|
      puts "Usages: #{use[:count]} Scenarios: #{use[:scenarios]} Use/Scenario: #{use[:use_scenario]}  Step: #{use[:regex]}"
    end
    #pp grouping(@scenarios)
    s = grouping(@scenarios)
    s.sort{|a,b| a[:incount] <=> b[:incount] }.each do |scenario|
       YAML::dump(scenario) if scenario[:incount] > 100
    end
  end

  def steps_per_scenario(scenarios)
    scen_count = scenarios.length
    step_count = 0.0
    scenarios.each do |scenario|
      step_count += scenario.steps.length
    end
    step_count / scen_count
  end

  def uniq_steps_per_scenario(scenarios)
    total_steps = 0.0
    uniq_steps = 0.0
    scenarios.each do |scen|
      total_steps += scen.steps.length
      uniq_steps += scen.uniq_steps.length
    end
    total_steps / uniq_steps
  end

  def step_usage(scenarios)
    steps = instance.steps.collect{|step| {:id => step.id, :regex => step.regex, :count => 0, :scenarios => 0} }
    scenarios.each do |scenario|

      scenario.steps.each do |step|
        step_hash = steps.detect{|finded| finded[:id] == step.id}
        step_hash[:count] += 1 if step_hash
      end

      scenario.uniq_steps.each do |step|
        step_hash = steps.detect{|finded| finded[:id] == step.id}
        step_hash[:scenarios] += 1 if step_hash
      end

    end

    steps.each do |step|
      if step[:scenarios] > 0
        step[:use_scenario] = step[:count] / Float(step[:scenarios])
      end
    end

    steps
  end

  def grouping(scenarios)
    steps = instance.steps.collect{|step| {:id => step.id, :regex => step.regex,  :in_steps => {}, :incount => 0 } }

    steps.each do |step|
      scenarios.each do |scenario|
         used = scenario.steps.any?{|s| s.id == step[:id]}

        if used
          scenario.steps.each do |scen_step|
            if step[:in_steps][scen_step.id]
              step[:in_steps][scen_step.id][:count] += 1
            else
              step[:in_steps][scen_step.id] = {}
              step[:in_steps][scen_step.id][:count] = 1
              step[:in_steps][scen_step.id][:regex] = scen_step.regex
            end
          end
          step[:incount] = begin
            sum = 0
            #puts step[:in_steps].inspect
            step[:in_steps].each do |key,val|
              sum += val[:count]
            end
            sum
          end
        end

      end

    end
    steps
  end

  def step(id)
    instance.steps.detect{|step| step.id == id}
  end

  def instance
    @instance ||= begin
      new_inst = StepInstance.new

      Dir.glob(@step_files).each do |file_name|
        new_inst.instance_eval File.read(file_name)
      end
      new_inst
    end
  end
end