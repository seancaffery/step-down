require 'optparse'

module Stepdown
  class Options
    attr_reader :steps_dir, :features_dir, :reporter, :quiet

    OUTPUT_FORMATS = ["html", "text", "quiet"]

    def parse(params)
      @steps_dir = "features/step_definitions"
      @features_dir = "features"
      @reporter = "html"
      @quiet = false
      parser = OptionParser.new do |opts|
        opts.banner = <<-USE 
        Usage: stepdown
               stepdown --steps <STEP_DEFINITION_DIRECTORY> --features <FEATURE_FILE_DIRECTORY>
        USE

        opts.separator("")

        opts.on("--output=TYPE", OUTPUT_FORMATS, "Select ouput format (#{OUTPUT_FORMATS.join(',')}). Default: html") do |o|
          @reporter = o
        end

        opts.on("--steps=STEPS_DIR", "Step definition directory. Default: ./features/step_definitions") do |o|
          @steps_dir = o
        end

        opts.on("--features=FEATURE_DIR", "Feature file directory. Default: ./features") do |o|
          @features_dir = o
        end

        opts.on("--quiet", "-q", "Supress output") do |o|
          @quiet = true
        end

        opts.on_tail("-h", "--help", "You're looking at it") do |o|
          puts opts
          exit
        end

      end

      begin
        parser.parse(params)

      rescue OptionParser::ParseError => e
        puts e
        exit 1
      end
    end

    def validate(io = STDOUT)
      @steps_dir = File.join(Dir.pwd, @steps_dir)
      @features_dir = File.join(Dir.pwd, @features_dir)

      [@steps_dir, @features_dir].each do |dir|
        unless File.exists?(dir)
          io.puts "Directory #{dir} does not exist"
          exit 1
        end
      end

    end
  end
end
