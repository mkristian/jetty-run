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
require 'maven/ruby/pom_magic'
require 'maven/jetty/jetty_project'
require 'fileutils'

module Maven
  module Jetty
    class PomMagic < Maven::Ruby::PomMagic

      def generate_pom( dir = '.', *args )
        proj = JettyProject.new( dir )

        ensure_web_xml( dir, proj )
        ensure_mavenfile( dir, File.dirname( __FILE__ ) )
        ensure_keystore( dir )
        ensure_overlays( dir )

        load_standard_files( dir, proj )

        pom_xml( dir, proj, args )
      end

      def ensure_overlays( dir )
        target = target_dir( dir )
        Dir[ File.join( File.dirname( __FILE__ ), "override-*-web.xml" ) ].each do |f|
          FileUtils.cp( f, target )
        end
      end

      def ensure_web_xml( dir, proj, source = File.dirname( __FILE__ ), target = nil )
        target ||= File.join( config_dir( dir ), 'web.xml' )
        if !File.exists?( target ) && !File.exists?( File.join( dir, 'src', 'main', 'webapp', 'WEB-INF', 'web.xml' ) )
          flavour = rails?( dir ) ? "rails" : "rack"
          web_xml = File.join( source, "#{flavour}-web.xml" )
          FileUtils.cp( web_xml, target )
          warn "created #{target.sub( /#{dir}\/?/, './' )}"
        end
      end

      def rails?( dir )
        File.exists? File.join( dir, 'config', 'application.rb' )
      end

      def config_dir( dir )
        if File.exists?( File.join( dir, 'config' ) )
          File.join( dir, 'config' )
        else
          dir
        end
      end

      def target_dir( dir )
        target = File.join( dir, 'target', 'jetty' )
        unless File.exists?( target )
          FileUtils.mkdir_p target
        end
        target
      end

      def ensure_keystore( dir )
        target = File.join( target_dir( dir ), 'server.keystore' )
        if !File.exists?( target ) && !File.exists?( File.join( dir, 'src', 'test', 'resources', 'server.keystore' ) )
          store =   File.join( File.dirname( __FILE__ ), "server.keystore" )
          FileUtils.cp( store, target )
        end
      end

    end
  end
end