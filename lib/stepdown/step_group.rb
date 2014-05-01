require 'cgi'
require 'stepdown/step_collection'

module Stepdown
  class StepGroup
    attr_reader :id, :regex, :use_count

    def initialize(step)
      @id = step.id
      @regex = step.regex
      @use_count = 0
      @step_collection = Stepdown::StepCollection.new
    end

    def step_collection
      @step_collection.sort
    end

    def add_step(step)
      @step_collection.add_step(step.id, step.regex)
    end

    def add_steps(step_set)
      step_set.each{|step| add_step(step)}
    end

    def update_use_count(num_steps)
      @use_count += num_steps
    end

    def group_graph
      base = "https://chart.googleapis.com/chart?cht=gv:dot&chl=graph{"
      base += "a [label=\"#{CGI.escape(CGI.escapeHTML(@regex.inspect.to_s))}\"];"

      step_collection[0..10].each do |step|

        next if step.regex.nil?
        base += "a--\"#{CGI.escape(CGI.escapeHTML(step.to_s))}\" [weight=#{step.count}];"
        #a [label=\"#{grouping.in_steps[0][:step].regex.inspect}\"]; a--b [penwidth=3,weight=2];b--d}"
      end
      base += "}"
      base
    end
  end
end
