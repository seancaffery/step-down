require 'fileutils'
require 'stepdown/reporter'
require 'erb'

module Stepdown
  class HTMLReporter < Reporter

    def output_overview()
      puts "Generating report..." unless Stepdown.quiet
      FileUtils.mkdir_p(Stepdown.output_directory)
      copy_files()

      write_html_from_erb('index')

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
      ['step_down.js', 'jquery-1.6.1.min.js', 'bluff-min.js', 'excanvas.js',
       'js-class.js', 'stepdown.css', 'bootstrap.min.css', 'jquery.flot.min.js'].each do |file|
        src = File.expand_path("#{File.dirname(__FILE__)}/../../public/#{file}")
        FileUtils.cp(src, File.join(Stepdown.output_directory, "#{file}"))
      end
    end
  end
end
