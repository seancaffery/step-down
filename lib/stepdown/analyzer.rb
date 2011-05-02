

module Stepdown
  class Analyzer
    def initialize(steps_dir, feature_dir, reporter)
      @feature_dir = feature_dir
      @steps_dir = steps_dir
      @reporter = reporter
    end

    def analyse
      puts "Parsing feature files..." unless Stepdown.quiet
      scenarios = process_feature_files(feature_files)

      puts "Performing analysis..." unless Stepdown.quiet

      reporter = reporter(@reporter, scenarios, instance.step_collection)
      reporter.output_overview

    end

    def process_feature_files(feature_files)
      parser = Stepdown::FeatureParser.new

      scenarios = []
      feature_files.each do |feature_file|
        scenarios << parser.process_feature(feature_file, instance)
      end
      scenarios.flatten
    end

    def reporter(type, scenarios, step_collection)
      case type
        when "html"
          Stepdown::HTMLReporter.new(scenarios, step_collection)
        when "text"
          Stepdown::TextReporter.new(scenarios, step_collection)
        when "quiet"
          Stepdown::Repoerter.new(scenarios, step_collection)
      end
    end

    def step(id)
      instance.steps.detect{|step| step.id == id}
    end

    def instance
      @instance ||= begin
        new_inst = Stepdown::StepInstance.new

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
end
