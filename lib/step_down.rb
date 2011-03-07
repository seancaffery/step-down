require 'feature_parser'
require 'step_instance'
require 'html_reporter'
require 'text_reporter'

class StepDown

  def initialize(steps_dir, feature_dir, reporter)
    @feature_dir = feature_dir
    @steps_dir = steps_dir
    @reporter = reporter
  end

  def analyse
    puts "Parsing feature files..."
    scenarios = process_feature_files(feature_files)

    puts "Performing analysis..."

    reporter = reporter(@reporter, scenarios, instance.steps)
    reporter.output_overview

  end

  def process_feature_files(feature_files)
    parser = FeatureParser.new

    scenarios = []
    feature_files.each do |feature_file|
      scenarios << parser.process_feature(feature_file, instance)
    end
    scenarios.flatten!
  end
 
  def reporter(type, scenarios, steps)
    case type
    when "html"
      HTMLReporter.new(scenarios, steps)
    when "text"
      TextReporter.new(scenarios, steps)
    end
  end

  def step(id)
    instance.steps.detect{|step| step.id == id}
  end

  def instance
    @instance ||= begin
      new_inst = StepInstance.new

      Dir.glob(step_files).each do |file_name|
        new_inst.instance_eval File.read(file_name)
      end
      new_inst
    end
  end

  private
  def feature_files
    return @feature_files if @feature_files
    @feature_files = Dir.glob(@feature_dir + '/**/*.feature')
  end
  
  def step_files
    return @step_files if @step_files
    @step_files = Dir.glob(@steps_dir + '/**/*.rb')
  end

end
