module Stepdown
  class Step

    attr_accessor :count
    attr_reader :id, :regex

    def initialize(id, regex)
      @id = id
      @regex = regex
      @count = 0
    end

    def <=>(other)
      other.count <=> self.count
    end

    def ==(other)
      self.id == other.id
    end

    def to_s
      regex.inspect.to_s
    end
  end
end
