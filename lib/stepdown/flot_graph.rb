require 'stepdown/graph'

module Stepdown
  class FlotGraph
    extend Stepdown::Graph

    def self.create_graph
      stats, labels = self.collect_stats

      content = <<-JS
      $(function(){
        $.plot($("#graph"),
        [
          {label: 'Total scenarios',
           data: #{stats[:number_scenarios].flatten.each_with_index.map{|a,i| [i,a]}.to_json} },
          {label: 'Total steps',
           data: #{stats[:total_steps].flatten.each_with_index.map{|a,i| [i,a] }.to_json } },
          {label: 'Total unused steps',
           data: #{stats[:unused_steps].flatten.each_with_index.map{|a,i| [i,a] }.to_json } }
        ],
        {
          series: {
           lines: { show: true },
           points: { show: true }
          },
          xaxis: {
            ticks: #{labels.flatten.each_with_index.map{|a,i| [i, a] }.to_json}
          },
          legend: { position: 'nw' }
        }
        )
        });
      JS
      File.open(File.join(Stepdown.output_directory, 'stepdown.js'), 'w') do
        |f| f << content 
      end
    end

  end
end
