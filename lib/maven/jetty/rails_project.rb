require 'maven/tools/rails_project'

module Maven
  module Jetty
    class RailsProject < Maven::Tools::RailsProject

      tags :dummy

      private

      CONNECTOR_XML = <<-XML

                <connector implementation="org.eclipse.jetty.server.nio.SelectChannelConnector">
                  <port>${jetty.port}</port>
                </connector>
                <connector implementation="org.eclipse.jetty.server.ssl.SslSelectChannelConnector">
                  <port>${jetty.sslport}</port>
                  <keystore>${project.basedir}/src/test/resources/server.keystore</keystore>
                  <keyPassword>123456</keyPassword>
                  <password>123456</password>
                </connector>
XML

      public


      def add_defaults
        super
        self.properties.merge!({
          "jetty.version" => '7.6.4.v20120524',
          "jetty.war" => "${project.build.directory}/${project.build.finalName}.war",
          "jetty.port" => '8080',
          "jetty.sslport" => '8443'
        })

        profile(:war).plugin("org.mortbay.jetty:jetty-maven-plugin",
                             "${jetty.version}")do |jetty|
            options = {
                :war => "${jetty.war}",
                :connectors => CONNECTOR_XML
              }
            jetty.with options
        end

        profile(:run) do |run|
          overrideDescriptor = '${project.build.directory}/jetty/override-${rails.env}-web.xml'
          run.activation.by_default
          run.plugin("org.mortbay.jetty:jetty-maven-plugin",
                       "${jetty.version}") do |jetty|
            options = {
                :webAppConfig => {
                  :overrideDescriptor => overrideDescriptor           
                },
                :systemProperties => {
                  :systemProperty => {
                    :name => 'jbundle.skip',
                    :value => 'true'
                  }
                },
                :connectors => CONNECTOR_XML
              }
            options[:webXml] = 'config/web.xml' if File.exists?('config/web.xml')
            jetty.with options
          end
        end

        profile(:warshell) do |exec|
          exec.plugin_repository('kos').url = 'http://opensource.kantega.no/nexus/content/groups/public/'
          exec.plugin('org.simplericity.jettyconsole:jetty-console-maven-plugin', '1.42').execution do |jetty|
            jetty.execute_goal(:createconsole)
            jetty.configuration.comment <<-TEXT
                  see http://simplericity.com/2009/11/10/1257880778509.html for more info
                -->
                <!--
		  <backgroundImage>${basedir}/src/main/jettyconsole/puffin.jpg</backgroundImage>
		  <additionalDependencies>
		    <additionalDependency>
		      <artifactId>jetty-console-winsrv-plugin</artifactId>
		    </additionalDependency>
		    <additionalDependency>
		      <artifactId>jetty-console-requestlog-plugin</artifactId>
		    </additionalDependency>
		    <additionalDependency>
		      <artifactId>jetty-console-log4j-plugin</artifactId>
		    </additionalDependency>
		    <additionalDependency>
		      <artifactId>jetty-console-jettyxml-plugin</artifactId>
		    </additionalDependency>
		    <additionalDependency>
		      <artifactId>jetty-console-ajp-plugin</artifactId>
		    </additionalDependency>
		    <additionalDependency>
		      <artifactId>jetty-console-gzip-plugin</artifactId>
		    </additionalDependency>
		    <additionalDependency>
		      <artifactId>jetty-console-startstop-plugin</artifactId>
		    </additionalDependency>
		  </additionalDependencies>
TEXT
          end
        end
      end
    end
  end
end
