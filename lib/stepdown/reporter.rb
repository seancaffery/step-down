require 'delegate'

module Stepdown
  class Reporter < SimpleDelegator
    def initialize(statistics)
      super
    end
  end
end
