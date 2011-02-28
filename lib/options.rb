require 'optparse'

class Options

  OUTPUT_FORMATS = ["html", "text"]

  def self.parse(params)
    @@steps_dir = "features/step_definitions"
    @@features_dir = "features"
    @@reporter = "html"
    parser = OptionParser.new do |opts|
      opts.banner = "Usage: stepdown step_definition_dir feature_file_directory"

      opts.separator("")

      opts.on("--output=TYPE", OUTPUT_FORMATS, "Select ouput format (#{OUTPUT_FORMATS.join(',')}). Default: html") do |o|
        @@reporter = o
      end

      opts.on("--steps=STEPS_DIR", "Step definition directory. Default: ./features/step_definitions") do |o|
        @@steps_dir = o
      end

      opts.on("--features=FEATURE_DIR", "Feature file directory. Default: ./features") do |o|
        @@features_dir = o
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

  def self.validate
    @@steps_dir = File.join(Dir.pwd, @@steps_dir)
    @@features_dir = File.join(Dir.pwd, @@features_dir)

    [@@steps_dir, @@features_dir].each do |dir|
      unless File.exists?(dir)
        puts "Directory #{dir} does not exist"
        exit 1
      end
    end

  end

  def self.steps_dir
    @@steps_dir
  end

  def self.features_dir
    @@features_dir
  end

  def self.reporter
    @@reporter
  end

end
