require 'stepdown/reporter'

module Stepdown
  class TextReporter < Reporter

    def output_overview
      puts "Generating report..." unless Stepdown.quiet
      output = File.new(Stepdown.output_directory + '/analysis.txt', "w+")

      output.puts "Total number of scenarios: #{total_scenarios}"
      output.puts "Total number of steps: #{total_steps}"
      output.puts "Unused steps: #{unused_step_count}"
      output.puts "Steps per scenario: #{steps_per_scenario}"
      output.puts "Unique steps per scenario: #{unique_steps}"

      output.puts "Step usages"
      output.puts "Step|Total usage|Scenarios|Use per scenario"
      usages.each{|use| output.puts used_step_line(use) }

      output.puts "Unused steps"
      unused.each{|use| output.puts unused_step_line(use) }

      output.close

      puts "Report output to #{Stepdown.output_directory}/analysis.txt" unless Stepdown.quiet

    end

    def used_step_line(use)
      line = [use.step, use.total_usage, use.number_scenarios, use.use_scenario]
      line.join("|")
    end

    def unused_step_line(use)
      use.step
    end

  end
end
