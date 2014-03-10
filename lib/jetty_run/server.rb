require 'jetty_run/pom_runner'
module JettyRun
  class Server < PomRunner

    def copy_config_ru
      return unless web_inf
      FileUtils.cp( 'config.ru', web_inf )  
    end

    def run
      copy( 'web.xml' )
      copy( 'init.rb' )
      copy_config_ru

      maven.property( 'jetty.version', version )
      
      exec( :initialize,
            'dependency:unpack',
            "#{group_id}:jetty-maven-plugin:run" )
    end

  end
end
