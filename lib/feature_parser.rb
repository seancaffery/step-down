require 'step'
require 'scenario'

class FeatureParser

  def process_feature(file, instance)
    scenarios = []
    file_lines = read_feature_file(file)

    file_lines.each do |line|

      if line =~ /Scenario|Background/
        @scenario = Scenario.new
        scenarios << @scenario
      else
        step = instance.line_matches(line)
        @scenario.add_step(step) if step
      end
    end

    scenarios
  end

protected
  def read_feature_file(file_name)
    File.read(file_name).split("\n")
  end
end

