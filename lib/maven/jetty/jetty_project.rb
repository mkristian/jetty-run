#
# Copyright (C) 2013 Christian Meier
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
# the Software, and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
# FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
# IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
require 'maven/tools/gem_project'

module Maven
  module Jetty
    class JettyProject < Maven::Tools::GemProject

      tags :dummy

      private

      CONNECTOR_XML = <<-XML

                <connector implementation="org.eclipse.jetty.server.nio.SelectChannelConnector">
                  <port>${jetty.port}</port>
                </connector>
                <connector implementation="org.eclipse.jetty.server.ssl.SslSelectChannelConnector">
                  <port>${jetty.sslport}</port>
                  <keystore>${project.build.directory}/jetty/server.keystore</keystore>
                  <keyPassword>123456</keyPassword>
                  <password>123456</password>
                </connector>
XML

      public

      def initialize( dir = '.')
        @dir = dir
        super *[]
      end

      def rails?( dir = '.' )
        File.exists? File.join( dir, 'config', 'application.rb' )
      end

      def connector_xml
        if File.exists?( File.join( @dir, 'src', 'test','resources','server.keystore' ) )
          CONNECTOR_XML.sub( /..project.build.directory..jetty/, '${project.basedir}/src/test/resources' )
        else
          CONNECTOR_XML
        end
      end

      def web_xml
        if File.exists?( File.join( @dir, 'config', 'web.xml' ) )
          File.join( @dir, 'config', 'web.xml' )
        elsif File.exists?( File.join( @dir, 'web.xml' ) )
          'web.xml'
        end
      end

      def load_gemfile(file)
        super
        file = file.path if file.is_a?(File)
        if File.exists? file
          gem 'bundler'
          #plugin( :bundler, "${jruby.plugins.version}" ).execute_goal( :install )
        end
        super
      end

      def add_defaults
        super
        self.properties.merge!({
          "jetty.war" => "${project.build.directory}/${project.build.finalName}.war",
          "jetty.port" => '8080',
          "jetty.sslport" => '8443'
        })

        self.properties[ 'rails.env' ] = 'development' if rails?( @dir )

        plugin( :gem, "${jruby.plugins.version}" ).execute_goal( :initialize )
        
        profile(:war).plugin("org.mortbay.jetty:jetty-maven-plugin",
                             "${jetty.version}")do |jetty|
            options = {
                :war => "${jetty.war}",
                :connectors => connector_xml
              }
            jetty.with options
        end

        profile(:run) do |run|
          overrideDescriptor = rails?( @dir ) ? '${project.build.directory}/jetty/override-rails-${rails.env}-web.xml' : '${project.build.directory}/jetty/override-rack-web.xml'
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
              :connectors => connector_xml,
              :webXml => web_xml,
              :webAppSourceDirectory => "."
            }
            jetty.with options
          end
        end
      end
    end
  end
end