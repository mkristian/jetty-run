require 'maven/ruby/cli'
require 'maven/jetty/pom_magic'

module Maven
  module Jetty
    class Cli < Maven::Ruby::Cli

      def magic_pom( dir = '.', *args )
        PomMagic.new.generate_pom( File.expand_path( dir ), *args ) 
      end

    end
  end
end
