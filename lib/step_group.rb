require 'cgi'
require 'counting_step'
require 'step_collection'
class StepGroup
  attr_reader :id, :regex, :total_usage

  def initialize(step)
    @id = step.id
    @regex = step.regex
    @total_usage = 0
    @step_collection = StepCollection.new
  end

  def step_collection
    @step_collection.sort
  end

  def add_step(step)
    @step_collection << step
  end

  def update_use_count
    @total_usage = 0
    @step_collection.each do |step|
      @total_usage += step.count
    end
    @total_usage
  end

  def use_count
    @total_usage || 0
  end

  def group_graph
    base = "https://chart.googleapis.com/chart?cht=gv:dot&chl=graph{"
    base += "a [label=\"#{CGI.escape(CGI.escapeHTML(@regex.inspect.to_s))}\"];"

    in_steps[0..10].each do |id,in_step|

      next if in_step.regex.nil?
      base += "a--\"#{CGI.escape(CGI.escapeHTML(in_step.regex.inspect.to_s))}\" [weight=#{in_step.count}];"
      #a [label=\"#{grouping.in_steps[0][:step].regex.inspect}\"]; a--b [penwidth=3,weight=2];b--d}"
    end
    base += "}"
    base
  end

end
