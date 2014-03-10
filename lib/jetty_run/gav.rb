require 'war_pack/pom_runner'
module JettyRun
  module GAV

    def version
      @config[ 'version' ] || '9'
    end

    def jetty_version
      case version
      when '7'
        '7.6.14.v20131031'
      when '8'
        '8.1.14.v20131031'
      else
        '9.1.3.v20140225'
      end
    end

    def group_id
      case version
      when '8'
        'org.mortbay.jetty'
      when '7'
        'org.mortbay.jetty'
      else
        'org.eclipse.jetty'
      end
    end
  end
end
