require 'spec_helper'
require 'stepdown/graph'
require 'stepdown'

describe Stepdown::Graph do

  describe "collecting stats" do

    before :each do
      stats = [{:no_scen => 10, :unused => 2, :label => "label 1"}, 
               {:no_scen => 20, :unused => 3, :label => "label 2"}]
      Stepdown::Graph.stub!(:load_stats).and_return(stats)
    end

    it "should return the labels associated with a stat set" do
      Stepdown::Graph.collect_stats[1].should == ["label 1", "label 2"]
    end

    it "should break collect group stats based on given keys" do
      Stepdown::Graph.collect_stats[0].should == {:no_scen=>[10, 20], 
                                                  :unused=>[2, 3], 
                                                  :label=>["label 1", "label 2"]}
    end

  end

  describe "creating a label from a file name" do
    it "should return day/month" do
      Stepdown::Graph.date_from_file_name("20110512.yml").should == "12 / 5"
    end
  end

  describe "loading stat files" do
    Stepdown.output_directory = File.dirname(__FILE__) + '/../../fixtures'
    stats = Stepdown::Graph.load_stats
    stats.should == [{:number_scenarios=>[685],
                      :total_steps=>[531],
                      :steps_per_scenario=>["12.91"],
                      :label=>"11 / 6",
                      :unused_steps=>[123]},
                     {:number_scenarios=>[690],
                      :total_steps=>[533],
                      :steps_per_scenario=>["12.50"],
                      :label=>"12 / 6",
                      :unused_steps=>[123]}]

    stats.length.should == 2

  end

  describe "creating a bluff graph" do
    it "should turn given stats into bluff json" do

      labels = ['12 / 6']
      stats = {:number_scenarios=>[690],
               :total_steps=>[533],
               :steps_per_scenario=>["12.50"],
               :label=>"12 / 6",
               :unused_steps=>[123]}

      require 'stringio'
      io = StringIO.new
      File.stub!(:open).with(anything, anything).and_yield(io)

      Stepdown::Graph.should_receive(:collect_stats).and_return([stats, labels])
      Stepdown::Graph.const_set(:BLUFF_DEFAULT_OPTIONS, "DEFAULT")
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
      Stepdown::Graph.create_graph.string.should == expected_graph

    end
  end

end
