require 'spec_helper'
require 'stepdown/bluff_graph'
require 'stepdown'

describe Stepdown::BluffGraph do

  describe "creating a bluff graph" do
    it "should turn given stats into bluff json" do
      Stepdown.output_directory = File.dirname(__FILE__) + '/../../fixtures'

      labels = ['12 / 6']
      stats = {:number_scenarios=>[690],
               :total_steps=>[533],
               :steps_per_scenario=>["12.50"],
               :label=>"12 / 6",
               :unused_steps=>[123]}

      require 'stringio'
      io = StringIO.new
      File.stub(:open).with(anything, anything).and_yield(io)

      Stepdown::BluffGraph.should_receive(:collect_stats).and_return([stats, labels])
      stub_const("Stepdown::BluffGraph::BLUFF_DEFAULT_OPTIONS", "DEFAULT")
      expected_graph =  <<-GRAPH
        DEFAULT
        g.title = 'Stepdown';
        g.data('Total scenarios', [690]);
        g.data('Total steps', [533]);
        g.data('Total steps per scenario', [12.50]);
        g.data('Total unused steps', [123]);
        g.labels = {"0":"12 / 6"};
        g.draw();
      GRAPH
      Stepdown::BluffGraph.create_graph.string.should == expected_graph

    end
  end

end
