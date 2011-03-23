module Stepdown
  class Step

    attr_reader :id, :regex

    def initialize(id, regex)
      @id = id
      @regex = regex
    end

  end
end