require 'date'
module Stepdown
  class YamlWriter

    def self.write(stats)
      file_name = Date.today.strftime("%Y%m%d") + ".yml"
      file = File.new(file_name, "w+")

      YAML.dump(stats.to_h, file)
      file.close
    end

  end
end