class StepGroup
  attr_reader :id, :regex, :in_steps, :total_useage

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
    @total_useage = 0
    #puts step[:in_steps].inspect
    @in_steps.each do |key,val|
      @total_useage += val[:count]
    end
    @total_useage
  end

  def use_count
    @total_useage || 0
  end

end