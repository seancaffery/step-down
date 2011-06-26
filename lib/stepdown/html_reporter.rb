require 'fileutils'
require 'stepdown/reporter'
require 'haml'
require 'sass'

module Stepdown
  class HTMLReporter < Reporter

    def output_overview()
      puts "Generating report..." unless Stepdown.quiet
      FileUtils.mkdir_p(Stepdown.output_directory)
      copy_files

      ["main", "_unused", "_grouping", "_empty", "_usages"].each{ |template| write_html(template) }

      template = File.open(File.expand_path(File.dirname(__FILE__))  + '/../../templates/style.sass').read
      sass_engine = Sass::Engine.new(template)

      out = File.new(Stepdown.output_directory + '/style.css', 'w+')
      out.puts sass_engine.render

      out.close

      puts "\nReport output to #{Stepdown.output_directory}/analysis.html" unless Stepdown.quiet
    end

    protected

    def write_html(template)
      file = File.open(File.expand_path(File.dirname(__FILE__)) + "/../../templates/#{template}.html.haml").read()
      engine = Haml::Engine.new(file)

      out = File.new(Stepdown.output_directory + "/#{template}.html",'w+')
      out.puts engine.render(self)
      out.close
    end

    def copy_files
      ['step_down.js', 'jquery-1.6.1.min.js', 'bluff-min.js', 'excanvas.js', 'js-class.js'].each do |file|
        src = File.expand_path("#{File.dirname(__FILE__)}/../../public/#{file}")
        FileUtils.cp(src, File.join(Stepdown.output_directory, "#{file}"))
      end
    end
  end
end
