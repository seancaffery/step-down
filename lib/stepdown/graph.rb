
module Stepdown
  module Graph

    def collect_stats
      stats = Hash.new {|hsh, key| hsh[key] = [] }
      labels = []

      load_stats.each do |stat_set|
        stat_set.each{|key, val| stats[key].push val }
        labels.push(stat_set[:label])
      end

      [stats, labels]
    end

    def load_stats
      stat_collection = []
      Dir.glob("#{Stepdown.output_directory}/*.yml").sort.each do |file_name|
        stats = Hash.new {|hsh, key| hsh[key] = [] }
        file = File.open(file_name)
        stat_set = YAML::load(file)

        stat_set.each do |key, val|
          stats[key].push(val)
        end
        stats[:label] = date_from_file_name(file_name)
        stat_collection << stats

        file.close
      end

      stat_collection
    end

    def date_from_file_name(file_name)
      label_date = Date.strptime(file_name.match(/(\d+)/)[1], "%Y%m%d")
      "#{label_date.day} / #{label_date.month}"
    end

  end
end