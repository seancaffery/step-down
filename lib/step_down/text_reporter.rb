require 'reporter'

module Stepdown
  class TextReporter < Reporter

    def output_overview
      puts "Generating report..."
      output = File.new(Reporter::OUTPUT_DIR + '/analysis.txt', "w+")

      output.puts "Total number of scenarios: #{total_scenarios}"
      output.puts "Total numer of steps: #{total_steps}"
      output.puts "Steps per scenario: #{steps_per_scenario}"
      output.puts "Unique steps per scenario: #{unique_steps}"

      output.puts "Step usages"
      output.puts "Step|Total usage|Scenarios|Use per scenario"
      usages.each{|use| output.puts used_step_line(use) }

      output.puts "Unused steps"
      unused_steps.each{|use| output.puts unused_step_line(use) }

      output.close

      puts "Report output to #{Reporter::OUTPUT_DIR}/analysis.txt"

    end

    def used_step_line(use)
      line = [use.step.regex.inspect, use.total_usage, use.number_scenarios, use.use_scenario]
      line.join("|")
    end

    def unused_step_line(use)
      use.step.regex.inspect
    end

  end
end
