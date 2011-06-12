require 'json'
require 'date'
module Stepdown
  class Graph
    BLUFF_GRAPH_SIZE = "890x400"
    BLUFF_DEFAULT_OPTIONS = <<-EOS
      var g = new Bluff.Line('graph', "#{BLUFF_GRAPH_SIZE}");
      g.theme_37signals();
      g.tooltips = true;
      g.title_font_size = "24px"
      g.legend_font_size = "12px"
      g.marker_font_size = "10px"
    EOS

    def self.create_graph
      stats, labels = collect_stats
      label_set = {}
      labels.each_with_index do |label, i|
        label_set.update({i => label})
      end

      content = <<-EOS
        #{BLUFF_DEFAULT_OPTIONS}
        g.title = 'Stepdown';
        g.data('Total scenarios', [#{stats[:number_scenarios].join(',')}]);
        g.data('Total steps', [#{stats[:total_steps].join(',')}]);
        g.data('Total steps per scenario', [#{stats[:steps_per_scenario].join(',')}]);
        g.data('Total unused steps', [#{stats[:unused_steps].join(',')}]);
        g.labels = #{label_set.to_json};
        g.draw();
      EOS

      File.open(File.join(Stepdown.output_directory, 'stepdown.js'), 'w') do 
        |f| f << content 
      end
    end

    def self.collect_stats
      stats = Hash.new {|hsh, key| hsh[key] = [] }
      labels = []

      load_stats.each do |stat_set|
        stat_set.each{|key, val| stats[key].push val }
        labels.push(stat_set[:label])
      end

      [stats, labels]
    end

    def self.load_stats
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

    def self.date_from_file_name(file_name)
      label_date = Date.strptime(file_name.match(/(\d+)/)[1], "%Y%m%d")
      "#{label_date.day} / #{label_date.month}"
    end

  end
end
