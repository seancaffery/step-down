require 'googlecharts'
require 'stepdown/graph'

module Stepdown
  class GoogleChart
    extend Stepdown::Graph

    def self.create_graph
      stats, labels = collect_stats
      label_set = {}
      labels.each_with_index do |label, i|
        label_set.update({i => label})
      end
      #Gchart.line(  :size => '200x300',
      #              :title => "example title",
      #              :bg => 'efefef',
      #              :legend => ['first data set label', 'second data set label'],
      #              :data => [10, 30, 120, 45, 72])

      all_values = stats[:number_scenarios].flatten + stats[:total_steps].flatten
      puts all_values.min
      puts stats[:total_steps].flatten.sort.inspect
      puts stats[:number_scenarios].flatten.sort.inspect
      chart = Gchart.line(:type => :line,
                    :size => '600x300',
                    :title => "Stepdown",
                    :theme => :pastel,
                    :axis_with_labels => ['x', 'y'],
                                  :axis_labels => [labels],
                                  #:axis_range => [nil, [2,17,5]],
                    #:axis_with_label => 'x,y,r,t',
                    #:axis_labels => ["a|b","a|b","a|b","a|b"],
                    :bg => 'ffffff',
                    :legend => ['Total scenarios', 'Total steps'],
                    :data => [stats[:number_scenarios].flatten.map{|a| a * 0.128865979},
                              stats[:total_steps].flatten.map{|a| a * 0.128865979},
                              #stats[:steps_per_scenario].flatten,
                              #stats[:unused_steps].flatten],
                        ],
                    #:axis_range => [nil, [(all_values.min).to_i, (all_values.max * 1.1).to_i]],
                    #:data => [[1,2,3], [6,7,8]],
                    :max_value => false, #(all_values.max * 1.1).to_i,
                    :encoding => 'text',
                    :filename => "/tmp/chart.png")

      puts chart.inspect
      chart.file
      #content = <<-EOS
      #  #{BLUFF_DEFAULT_OPTIONS}
      #  g.title = 'Stepdown';
      #  g.data('Total scenarios', [#{stats[:number_scenarios].join(',')}]);
      #  g.data('Total steps', [#{stats[:total_steps].join(',')}]);
      #  g.data('Total steps per scenario', [#{stats[:steps_per_scenario].join(',')}]);
      #  g.data('Total unused steps', [#{stats[:unused_steps].join(',')}]);
      #  g.labels = #{label_set.to_json};
      #  g.draw();
      #EOS
      #
      #File.open(File.join(Stepdown.output_directory, 'stepdown.js'), 'w') do
      #  |f| f << content
      #end
    end
  end
end