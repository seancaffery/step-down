require 'optparse'

class Options

  def self.parse(params)
    @@steps_dir = "features/step_definitions"
    @@features_dir = "features"

    parser = OptionParser.new do |opts|
      opts.banner = "Usage: stepdown step_definition_dir feature_file_directory"

      opts.separator("")

      opts.on("--steps=directory", "Step definition directory") do |o|
        @@steps_dir = o
      end

      opts.on("--features=directory", "Feature file directory") do |o|
        @@features_dir = o
      end

      opts.on_tail("-h", "--help", "You're looking at it") do |o|
        puts opts
        exit
      end

    end

    begin
      parser.parse(params)

      if parser.getopts.length == 0 && params.length == 2
        @@steps_dir = params[0]
        @@features_dir = params[1]
      end

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

end