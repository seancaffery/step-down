require File.expand_path(File.dirname(__FILE__) + '/step')
class CountingStep < Step
  attr_accessor :count

  def initialize(id, regex)
    @count = 0
    super(id, regex)
  end

  def <=>(step)
    self.count <=> step.count
  end

end