require 'jetty_run/pom_runner'
require 'zip/zip'
module JettyRun
  class War < PomRunner

    def clean?
      false
    end

    def warfile
      ( Dir[ '*.war' ] + Dir[ File.join( work_dir, '*.war' ) ] ).first
    end

    def run( file = nil )
      file ||= warfile
      raise 'no war file found' unless file
      raise "#{file} does not exists" unless File.exists?( file )
      file = File.expand_path( file || warfile )

      maven.property( 'jetty.version', jetty_version )
      maven.property( 'jetty.war', file )

      exec "#{group_id}:jetty-maven-plugin:deploy-war"
    end
  end
end
