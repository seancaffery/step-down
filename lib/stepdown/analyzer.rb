require 'gherkin/parser/parser'

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

      stats = Statistics.new(scenarios, instance.step_collection)

      reporter = reporter(@reporter, stats)
      reporter.output_overview

      Stepdown::YamlWriter.write(stats)
      Stepdown::Graph.create_graph

    end

    def process_feature_files(feature_files)
      listener = Stepdown::FeatureParser.new(instance)

      parser = Gherkin::Parser::Parser.new(listener, true, 'root')

      feature_files.each do |feature_file|
        parser.parse(File.read(feature_file), feature_file, 0)
      end
      listener.scenarios
    end

    def reporter(type, stats)
      case type
        when "html"
          Stepdown::HTMLReporter.new(stats)
        when "text"
          Stepdown::TextReporter.new(stats)
        when "quiet"
          Stepdown::Reporter.new(stats)
      end
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
