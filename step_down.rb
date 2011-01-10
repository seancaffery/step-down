require 'lib/feature_parser'
require 'pp'
require 'haml'
require 'sass'

require 'lib/step_instance'
require 'lib/step_group'
require 'lib/step_usage'
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

    @usage = step_usage(@scenarios)
    @usage = @usage.sort{|a,b| b.total_usage <=> a.total_usage }
    output_overview
#    usage.each do |use|
#      puts "Usages: #{use.total_usage} Scenarios: #{use.number_scenarios} Use/Scenario: #{use.use_scenario}  Step: #{use.step.regex}"
#    end
#    #pp grouping(@scenarios)
#    s = grouping(@scenarios)
#    s.sort{|a,b| a.use_count <=> b.use_count}.each do |scenario|
#       puts YAML::dump(scenario) if scenario.use_count > 100  &&  scenario.use_count < 500
#    end
  end

  def output_overview()
    template = File.open('templates/main.html.haml').read()
    engine = Haml::Engine.new(template)

    variables = {:total_scenarios => @scenarios.length,
                 :total_steps => instance.steps.length,
                 :steps_per_scenario => steps_per_scenario(@scenarios),
                 :unique_steps => uniq_steps_per_scenario(@scenarios),
                 :usages => @usage.select{|use| use.total_usage > 0 },
                 :unused_steps => @usage.select{|use| use.total_usage == 0}
     }

    out = File.new('public/analysis.html','w+')
    out.puts engine.render(self, variables)
    out.close

    template = File.open('templates/style.sass').read
    sass_engine = Sass::Engine.new(template)

    out = File.new('public/style.css', 'w+')
    out.puts sass_engine.render

    out.close
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
    usages = instance.steps.collect{|step| StepUsage.new(step) }
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
        usage.use_scenario = usage.total_usage / Float(usage.number_scenarios)
      end
    end

    usages
  end

  def grouping(scenarios)
    step_groups = instance.steps.collect{|step| StepGroup.new(step) }

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
    step_groups
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