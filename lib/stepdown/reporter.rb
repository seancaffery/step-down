require 'stepdown/step_group'
require 'stepdown/step_usage'

module Stepdown
  class Reporter < Delegator
    
    def initialize(statistics)
      @statistics = statistics
      super @statistics
    end

    def __getobj__
      @statistics  
    end

  end
end

