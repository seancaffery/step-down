require 'cgi'
class StepGroup
  attr_reader :id, :regex, :in_steps, :total_usage

  def initialize(step)
    @id = step.id
    @regex = step.regex
    @total_usage = 0
    @in_steps = {}
  end

  def add_step(step)
    if @in_steps[step.id]
      @in_steps[step.id][:count] += 1
    else
      @in_steps[step.id] = {}
      @in_steps[step.id][:count] = 1
      @in_steps[step.id][:step] = step
    end
  end

  def update_use_count
    @total_usage = 0
    #puts step[:in_steps].inspect
    @in_steps.each do |key,val|
      @total_usage += val[:count]
    end
    @total_usage
  end

  def use_count
    @total_usage || 0
  end

  def group_graph
    base = "https://chart.googleapis.com/chart?cht=gv:circo&chl=graph{"
    base += "a [label=\"#{CGI.escape(CGI.escapeHTML(@regex.inspect.to_s))}\"];"

    @in_steps.each do |id,in_step|

      next if in_step[:step].regex.nil?
      base += "a--\"#{CGI.escape(CGI.escapeHTML(in_step[:step].regex.inspect.to_s))}\" [weight=#{in_step[:count]}];"
      #a [label=\"#{grouping.in_steps[0][:step].regex.inspect}\"]; a--b [penwidth=3,weight=2];b--d}"
    end
    base += "}"
    base
  end

end