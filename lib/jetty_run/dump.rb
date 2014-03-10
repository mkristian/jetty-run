require 'war_pack/dumper'
require 'jetty_run/gav'
module JettyRun
  class Dump  < WarPack::Dumper

    include GAV

    # overwrite method from Dumper
    def pom_file
      File.join( File.dirname( __FILE__ ), 'jetty_pom.rb' )
    end

    def call_prepend( file )
      file.puts <<EOF
properties( 'jetty.version' => '#{jetty_version}',
            'jetty.group_id' => '#{group_id}' )
EOF
    end
  end
end
