class HTMLReporter

  attr_reader :scenarios, :usages, :steps

  def initialize(scenarios, usages, steps)
    @scenarios = scenarios
    @usages = usages
    @steps = steps
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

  def output_overview()
    template = File.open('templates/main.html.haml').read()
    engine = Haml::Engine.new(template)

    out = File.new('public/analysis.html','w+')
    out.puts engine.render(self)
    out.close

    template = File.open('templates/style.sass').read
    sass_engine = Sass::Engine.new(template)

    out = File.new('public/style.css', 'w+')
    out.puts sass_engine.render

    out.close
  end

  protected
  def steps_scenario(scenarios)
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

end