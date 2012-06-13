require 'ruby_maven'
require 'maven/jetty/rails_project'

module Maven
  module Jetty
    class RubyMaven < Maven::RubyMaven

      def new_rails_project
        RailsProject.new
      end

      def exec(*args)
        # first make sure the jetty resources are in place
        if !File.exists?(File.join('config', 'web.xml')) && !File.exists?(File.join('src', 'main', 'webapp', 'WEB-INF', 'web.xml'))
          web_xml = Gem.find_files( 'maven/jetty/web.xml').first
          FileUtils.cp(web_xml, 'config')
        end

        # now just continue
        super
      end
    end
  end
end
