class StepGroup
  attr_reader :id, :regex, :in_steps, :incount

  def initialize(id, regex)
    @id = id
    @regex = regex
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
    @incount = 0
    #puts step[:in_steps].inspect
    @in_steps.each do |key,val|
      @incount += val[:count]
    end
    @incount
  end

  def use_count
    @incount || 0
  end

end