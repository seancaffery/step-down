require 'fileutils'
require 'stepdown/reporter'

module Stepdown
  class HTMLReporter < Reporter

    def output_overview()
      puts "Generating report..." unless Stepdown.quiet
      FileUtils.mkdir_p(Stepdown.output_directory)
      copy_files()

      ["index", "_empty", "_unused", "_grouping", "_usages"].each { |template| write_html_from_erb(template) }

      puts "\nReport output to #{Stepdown.output_directory}/index.html" unless Stepdown.quiet
    end

    protected

    def write_html_from_erb(template)
      file = File.open(File.expand_path(File.dirname(__FILE__)) + "/../../templates/#{template}.html.erb")
      erb = ERB.new(file.read())

      file.close
      out = File.new(Stepdown.output_directory + "/#{template}.html",'w+')
      out.puts erb.result(binding())
      out.close
    end

    def copy_files
      ['step_down.js', 'jquery-1.6.1.min.js', 'bluff-min.js', 'excanvas.js', 'js-class.js', 'stepdown.css'].each do |file|
        src = File.expand_path("#{File.dirname(__FILE__)}/../../public/#{file}")
        FileUtils.cp(src, File.join(Stepdown.output_directory, "#{file}"))
      end
    end
  end
end
