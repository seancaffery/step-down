require 'spec_helper'
require 'step_instance'
require 'step'


describe Stepdown::StepInstance do

  before :each do 
    @step_instance = Stepdown::StepInstance.new
  end

  it "should deal with missing constants" do
    expect { @step_instance.instance_eval("MissingConst") }.to_not raise_error
    expect { @step_instance.instance_eval("MissingConst::MissingClass") }.to_not raise_error
    expect { @step_instance.instance_eval("MissingConst::MissingClass.missing_method") }.to_not raise_error
  end

  it "should deal with missing methods" do
     expect { @step_instance.doesnt_exist }.to_not raise_error
     expect { Stepdown::StepInstance.doesnt_exist }.to_not raise_error
  end

  describe "returning steps" do
    it "should return parsed steps" do
      @step_instance.Given(/given/)
      @step_instance.When(/when/)
      @step_instance.Then(/then/)

      expect(@step_instance.step_collection.length).to eq 3
    end

  end

  describe "returning matched steps" do
    it "should return nil when no matching step found" do
      @step_instance.Given(/some step/)
      expect(@step_instance.line_matches("Given some other step")).to be_nil
    end

    it "should parse And steps" do
      @step_instance.Given(/matched step/)
      expect(@step_instance.line_matches("And matched step").regex).to eq(/matched step/)
    end

    it "should parse Given steps" do
      @step_instance.Given(/matched step/)
      expect(@step_instance.line_matches("Given matched step").regex).to eq(/matched step/)
    end

    it "should parse When steps" do
      @step_instance.When(/matched step/)
      expect(@step_instance.line_matches("When matched step").regex).to eq(/matched step/)
    end

    it "should parse Then steps" do
      @step_instance.Then(/matched step/)
      expect(@step_instance.line_matches("Then matched step").regex).to eq(/matched step/)
    end

    it "should parse And steps" do
      @step_instance.And(/matched step/)
      expect(@step_instance.line_matches("And matched step").regex).to eq(/matched step/)
    end
  end

  describe "parsing step definitions" do
    before :each do
      @regex = /reg/
    end

    it 'defines methods for all valid code words' do
      Gherkin::I18n.code_keywords.each do |code|
        expect do
          @step_instance.send(code, @regex)
        end.to_not raise_error
      end

      expect(Gherkin::I18n.code_keywords.count).to eq(@step_instance.step_collection.count)
    end
  end
end
