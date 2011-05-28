require 'stepdown/feature_parser'
require 'stepdown/step_instance'
require 'stepdown/html_reporter'
require 'stepdown/text_reporter'
require 'stepdown/statistics'
require 'stepdown/analyzer'

require 'rubygems'
require 'bundler/setup'

module Stepdown
  class << self
    attr_accessor :quiet
  end
end
