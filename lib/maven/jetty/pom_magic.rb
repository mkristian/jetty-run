require 'maven/ruby/pom_magic'
require 'maven/jetty/jetty_project'
require 'fileutils'

module Maven
  module Jetty
    class PomMagic < Maven::Ruby::PomMagic

      def generate_pom( dir = '.', *args )

        proj = JettyProject.new

        ensure_web_xml( dir, proj )
        ensure_mavenfile( dir )
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

      # def first_gemspec( dir = '.' )
      #   gemspecs = Dir[ File.join( dir, "*.gemspec" ) ]
      #   if gemspecs.size > 0
      #     File.expand_path( gemspecs[ 0 ] )
      #   end
      # end

      # def file( name, dir = '.' )
      #   File.expand_path( File.join( dir, name ) )
      # end

      # def pom_xml( dir = '.', proj, args )
      #   index = args.index( '-f' ) || args.index( '--file' )
      #   name = args[ index + 1 ] if index
      #   pom = File.join( dir, name || '.pom.xml' )
      #   File.open(pom, 'w') do |f|
      #     f.puts proj.to_xml
      #   end
      #   args += ['-f', pom] unless name
      #   args
      # end

    end
  end
end
