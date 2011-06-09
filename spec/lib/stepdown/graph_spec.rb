require 'spec_helper'
require 'stepdown/graph'

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

  describe "creating a bluff graph" do

  end

  describe "loading stat files" do
    
  end

end
