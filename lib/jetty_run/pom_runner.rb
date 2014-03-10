require 'war_pack/pom_runner'
require 'jetty_run/gav'
module JettyRun
  class PomRunner < WarPack::PomRunner

    include GAV
    
    def pom_file
      file( 'jetty_pom.rb' )
    end

    def file( file )
      File.join( File.dirname( __FILE__ ), file )
    end

    def exec( *args )
      maven.property( 'jetty.group_id', group_id )
      maven.property( 'jetty.version', jetty_version )
      super
    end
  end
end
