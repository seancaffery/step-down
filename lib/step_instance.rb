class StepInstance
  def initialize
    @steps = []
  end

  def Given(regex,&block)
    define_step(regex,&block)
  end

  def When(regex,&block)
    define_step(regex,&block)
  end

  def Then(regex,&block)
    define_step(regex,&block)
  end

  def define_step(regex,&block)
    @steps << regex
  end

  def method_missing(*args)
    #nothing
  end

  def require(*args)
    # do nothing
  end

  def line_matches(line,line_no,file)
    stripped_line = line.strip.gsub(/^(And|Given|When|Then) (.*)$/,'\2')

    @steps.each_with_index do |regex,i|
      match = regex.match(stripped_line)
      if match
        return steps[i]
      end
    end

    return nil
  end

  def steps
    return @step_definitions if @step_definitions
    @step_definitions = []
    @steps.each_with_index do |regex, i|
      @step_definitions << Step.new(i, regex)
    end
    @step_definitions
  end

end