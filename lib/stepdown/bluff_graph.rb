require 'json'
require 'date'
require 'stepdown/graph'

module Stepdown
  class BluffGraph
    extend Stepdown::Graph

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
      stats, labels = self.collect_stats
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

  end
end
