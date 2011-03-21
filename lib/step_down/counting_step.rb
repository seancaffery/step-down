require 'step'
class CountingStep < Step
  attr_accessor :count

  def initialize(id, regex)
    @count = 0
    super(id, regex)
  end

  def <=>(other)
    other.count <=> self.count
  end

end